<template>
  <div id="app" class="columns">
    <div v-for="list in original_lists" class="column is-3">
      {{ list.name }}
    </div>
  </div>
</template>

<script>
export default {
  props: ["original_lists"],
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
