<template>
  <div v-if="todoTree" class="flex flex-col grow">
    <div class="flex justify-start min-w-max border-2 rounded-md border-black grow">
      <div class="flex flex-1 flex-col m-2 flex-grow-2 gap-1">
        <TodoMilestone 
          v-if="String(todoTree.type) === 'MILESTONE'"
          :todo-tree="todoTree" 
          :expanded="expanded"
          :expanded-all-children="expandAllChildren"
          :detailed="detailed"
          @selected="onSelected"
          @toggle-expansion="onToggleExpansion"
          @expand-all-children="onExpandAllChildren"
          @open-detail="onSelected"
          @close-detail="onSelected"
        />
        <TodoTask 
          v-if="String(todoTree.type) === 'TASK'"
          :todo-tree="todoTree" 
          :detailed="detailed"
          @selected="onSelected"
          @subtask-added="onSubtaskAdded"
          @closed="onClosed"
          @reopened="onReopened"
          @open-detail="onSelected"
          @close-detail="onSelected"
        />
        <div class="flex gap-1" v-if="detailed">
          <TodoModal 
            @updated="onAddSubtask" 
            :parent-todo="todoTree"
          />
          <UButton
            v-if="String(todoTree.type) === 'TASK'"
            icon="i-heroicons-minus-circle"
            size="xs"
            color="white" 
            square 
            variant="solid" 
            title="Delete" 
            @click="onDelete"
          />
          <TodoModal 
            @updated="onAddSubtask" 
            :todo="todoTree"
          />
          <TodoAssign :todo="todoTree" @assigned="onAssigned" />
          <div>{{ todoTree.owner?.displayName }}</div>
        </div>
      </div>
    </div>
    <div v-if="showLoadChildren" class="flex justify-start min-w-max grow ml-10 hover:cursor-pointer" @click="onLoadChildrenSubtree">
      Load {{ todoTree.hiddenChildren?.totalCount ?? 0 }} children...
    </div>
    <div v-if="showChildren" class="ml-3">
      <TodoTree 
        v-for="c in todoTree.children" 
        :todo-id="c.id.toString()"
        :sub-tree="c" 
        :tree-level="(treeLevel + 1)"
        :expand-all="expandAllChildren"
        :expanded-all-children="expandAllChildren"
        @updated="handleChildUpdated"
        @subtask-added="handleChildAddSubtask"
        @deleted="handleChildDelete"
      />
    </div>
  </div>

</template>

<script lang="ts" setup>
  const props = withDefaults(defineProps<{
    todoId: string,
    subTree?: Todo,
    treeLevel?: number,
    expandAll?: boolean
  }>(), {
    treeLevel: 0,
    expandAll: true
  })

  const emit = defineEmits<{
    (e: 'updated', todo: Todo): void
    (e: 'subtaskAdded', subTask: Todo): void    
    (e: 'assigned', todo: Todo): void
    (e: 'deleted', todoId: string): void
    (e: 'selected', todoId: string): void
  }>()

  const todoTree: Ref<Todo | undefined> = ref()
  const detailed = ref(false)
  const expanded = ref(false)
  const expandAllChildren = ref(false)

  const shallowMerge = (todo: Todo) => {
    todoTree.value = {
      ...todoTree.value,
      ...{
        name: todo.name,
        status: todo.status,
        owner: todo.owner,
      }
    } as Todo
  }

  // GRAPHQL QUERIES
  const shallowRefresh = async () => {
    const result = await GqlTodoById({
      id: props.todoId,
    })
    shallowMerge(result.todo) 
    emit('updated', todoTree.value as Todo)
  }
  const loadData = async () => {
    const result = await GqlTodoById({
      id: props.todoId,
    })
    todoTree.value = result.todo
  }
  const initializeData = async () => {
    if (props.treeLevel === 0) {
      await loadData()
    } else {
      todoTree.value = props.subTree
    }
    expanded.value = !!props.expandAll
    expandAllChildren.value = !!props.expandAll
  }
  initializeData()

  watch(()=>props.expandAll, ()=>{ expanded.value = true })

  // HANDLERS FOR ALL TODOS
  const onAddSubtask = async (todo: Todo) => {
    alert('hey')
    if (todoTree.value) {
      alert('you')
      const result = await GqlCreateTodo({
        name: todo.name,
        description: todo.description,
        parentTodoId: todo.parentTodoId
      })
      const children = [
        ...(todoTree.value.children || []),
        result.createTodo.todo
      ]
      todoTree.value.children = children
      // @ts-ignore
      todoTree.value.status = 'INCOMPLETE'
      // @ts-ignore
      todoTree.value.type = 'MILESTONE'
      emit('subtaskAdded', todoTree.value)
    }
  }
  const onAssigned = async (residentId: string) => {
    if (todoTree.value) {
      const result = await GqlAssignTodo({
        todoId: todoTree.value.id,
        residentId: residentId
      })
      await shallowMerge(result.assignTodo.todo)
    }
  }
  const onSelected = async () => {
    detailed.value = !detailed.value
  }
  // TASK SPECIFIC HANDLERS
  const onClosed = async () => {
    if (todoTree.value) {
      const result = await GqlUpdateTodoStatus({
        todoId: props.todoId,
        status: 'COMPLETE'
      })
      todoTree.value.status = result.updateTodoStatus.todo.status
      emit('updated', result.updateTodoStatus.todo)
    }
  }
  const onReopened = async () => {
    if (todoTree.value) {
      const result = await GqlUpdateTodoStatus({
        todoId: props.todoId,
        status: 'INCOMPLETE'
      })
      todoTree.value.status = result.updateTodoStatus.todo.status
      emit('updated', result.updateTodoStatus.todo)
    }
  }
  const onDelete = async () => {
    const result = await GqlDeleteTodo({
      todoId: props.todoId
    })
    emit('deleted', props.todoId)
  }
  // MILESTONE SPECIFIC HANDLERS
  const onExpandAllChildren = async () => {
    expanded.value = true
    expandAllChildren.value = true
  }
  const onToggleExpansion = async () => {
    expanded.value = !(expanded.value)
    if (!expanded.value) {
      expandAllChildren.value = false
    }
  }
  const onLoadChildrenSubtree = async () => {
    await loadData()
  }

  // HANDLERS FOR CHILD ITEMS THAT BUBBLE UP THE TREE
  const handleChildUpdated = async (todo: Todo) => {
    await shallowRefresh()
  }
  const handleChildAddSubtask = async (todo: Todo) => {
    await shallowRefresh()
  }
  const handleChildDelete = async (todoId: string) => {
    await loadData()
  }

  // COMPUTED VALUES
  const showChildren = computed(() => {
    return expanded.value && ((todoTree.value?.children?.length ?? 0) > 0)
  })
  const showLoadChildren = computed(() => {
    return todoTree.value?.hiddenChildren?.totalCount ?? 0 > 0
  })
</script>