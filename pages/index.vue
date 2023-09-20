<template>
  <DemoResidents />
  <!-- <DemoResidents v-if="environment === 'development'"  /> -->
</template>

<script lang="ts" setup>
  const environment = computed(() => {
    return process.env.NODE_ENV
  })
</script>
