<template>
  <div id="app" class="columns">
    <div v-for="list in original_lists" class="column is-3">
      <h6 class="title is-6">{{ list.name }}</h6>
      <hr />
      <div v-for="(card, index) in list.cards" class="card card-content">
        {{ card.name }}
      </div>
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
