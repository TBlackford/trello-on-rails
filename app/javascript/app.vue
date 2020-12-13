<template>
  <draggable :list="lists" :options="{group: 'lists'}" class="columns dragArea board" @end="listMoved">
    <List v-for="(list, index) in original_lists" :list="list" />
  </draggable>
</template>

<script>
import Rails from 'rails-ujs';
import draggable from 'vuedraggable';

import List from 'components/List';

export default {
  props: ["original_lists"],
  components: { draggable, List },
  data: function () {
    return {
      lists: this.original_lists
    }
  },
  methods: {
    listMoved: function(event) {
      var data = new FormData;
      data.append("list[position]", event.newIndex + 1);

      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: 'PATCH',
        data: data,
        dataType: 'json',
      })
    },
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 10px;
}
</style>
