<template>
  <UVerticalNavigation 
    :links="links"
    
  />
</template>

<script lang="ts" setup>
  const user = useSupabaseUser()
  const appStateStore = useAppStateStore()
  const collapsed = computed(() => {
    return appStateStore.navCollapsed
  })

  const links = computed(() => {
    return [
      {
        label: 'Address Book',
        icon: 'i-heroicons-book-open',
        to: {path: '/tools/address-book'},
        title: 'Address Book',
        permissionKey: ['p:address-book']
      },
      {
        label: 'Locations',
        icon: 'i-heroicons-globe-americas',
        to: '/tools/maps',
        title: 'Locations'
        // permissionKey: ['p:maps']
      }
    ]
      .map((l: any) => {
        return {
          ...l,
          label: collapsed.value ? '' : l.label
        }
      })
      .filter((l:any) => useHasPermission(user, l.permissionKey))
  })
</script>