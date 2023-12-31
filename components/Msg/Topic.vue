<template>
  <UCard v-if="topic" class="grow">
    <template #header>
      <div class="flex justify-center">{{ title || topic.name }}</div>
    </template>
    <div class="flex flex-col gap-1.5">
      <div class="flex gap-1">
        <div class="flex grow">
          <UTextarea
            v-model="content"
            :ui="{
              wrapper: 'flex grow'
            }"
          ></UTextarea>
        </div>
        <UButton 
          @click="handleSendMessage"
          :disabled="sendDisabled"
        >Send</UButton>
      </div>
      <div v-for="m in preppedMessages" class="flex flex-col">
        <div :class="m.display.justify">
          <div class="flex flex-col w-3/4 gap-0.5">
            <div class="flex text-sm font-bold">{{ m.postedBy.displayName }}</div>
            <div class="flex text-xs italic">{{ useFormatDateTimeString(m.createdAt) }}</div>
            <div :class="m.display.content">
              <UTextarea 
                :model-value="m.content"
                textareaClass="bg-red-400"
                color="red"
              />
            </div>
            <!-- <div :class="m.display.content">{{ m.content }}</div> -->
          </div>
        </div>
      </div>
    </div>
  </UCard>
</template>

<script lang="ts" setup>
  const props = defineProps<{
    topicId: string,
    title?: string
  }>()
  const user = useSupabaseUser()
  const topic = ref()
  const content = ref('')

  const loadData = async () => {
    const result = await GqlDiscussionById({
      topicId: props.topicId
    })
    topic.value = result.topic
  }
  loadData()

  const preppedMessages = computed(() => {
    return topic.value?.messages.map(m => {
      return {
        ...m,
        display: {
          justify: user.value?.user_metadata.display_name === m.postedBy.displayName ? 'flex justify-end' : 'flex justify-start',
          content: user.value?.user_metadata.display_name === m.postedBy.displayName ? 'flex p-1 rounded grow break-normal' :  'flex p-1 rounded grow break-normal'
        }
      }
    })
    .sort((a:Message,b:Message) => a.createdAt > b.createdAt ? -1 : 1)
  })

  const sendDisabled = computed(()=>{
    return content.value?.length === 0
  })

  const handleSendMessage = async () => {
    const result = await GqlUpsertMessage({
      messageInfo: {
        topicId: topic.value.id,
        content: content.value
      }
    })
    content.value = ''
    await loadData()
  }
  </script>
