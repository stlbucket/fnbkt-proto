<template>
  <UTable
    :rows="residents"
    :columns="columns"
    :sort="{ column: 'tenantName', direction: 'asc' }"
    :sortable="!disableSort"
    class="grow"
  >
    <template #email-data="{ row }">
      <NuxtLink :to="`/admin/app-tenant-residencies/${row.id}`">{{ row.email }}</NuxtLink>
    </template>
    <template #action-data="{ row }">
      <UButton v-if="rowActionName" @click="handleRowAction(row)">{{rowActionName}}</UButton>
    </template>
  </UTable>
</template>

<script lang="ts" setup>

  const props = defineProps<{
    residents: Resident[]
    rowActionName?: string
    showEmail?: boolean
    showDisplayName?: boolean
    disableSort?: boolean
  }>()

  const emit = defineEmits<{
    (e: 'rowAction', row: Resident): void
  }>()

  const handleRowAction = async (row: Resident) => {
    emit('rowAction', row)
  }

  const columns = computed(()=>{
    return [
      {key: 'action'},
      {key: 'displayName', label: 'Display Name', sortable: !props.disableSort},
      {key: 'email', label: 'Email', sortable: !props.disableSort},
      {key: 'status', label: 'Status', sortable: !props.disableSort},
      {key: 'tenantName', label: 'Tenant', sortable: !props.disableSort},
    ]
    .filter(c => c.key !== 'displayName' || props.showDisplayName )
    .filter(c => c.key !== 'email'  || props.showEmail)
    .filter(c => c.key !== 'action'  || props.rowActionName)
  })

</script>