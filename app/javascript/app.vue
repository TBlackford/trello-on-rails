<template>
  <draggable :list="lists" :options="{group: 'lists'}" class="columns dragArea" @end="listMoved">
    <div v-for="(list, index) in original_lists" class="column is-3">
      <h6 class="title is-6">{{ list.name }}</h6>

      <hr />

      <div v-for="(card, index) in list.cards" class="card card-content">
        {{ card.name }}
      </div>

      <br />

      <div class="card">
        <div class="card-content">
          <textarea v-model="messages[list.id]" class="textarea" rows="2"></textarea>

          <button @click="submitMessages(list.id)" class="button is-primary" style="width:100%; margin-top: 10px">Add</button>
        </div>
      </div>
    </div>
  </draggable>
</template>

<script>
import Rails from 'rails-ujs';
import draggable from 'vuedraggable';

export default {
  props: ["original_lists"],
  components: { draggable },
  data: function () {
    return {
      messages: {},
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

    submitMessages: function(list_id) {
      console.log(list_id);
      var data = new FormData;
      data.append("card[list_id]", list_id);
      data.append("card[name]", this.messages[list_id]);
      Rails.ajax({
        url: '/cards',
        type: "POST",
        data: data,
        dataType: 'json',
        success: (data) => {
          const index = this.lists.findIndex(item => item.id == list_id);
          console.log(index);
          this.lists[index].cards.push(data);
          this.messages[list_id] = "";
        }
      })
    }
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 20px;
}
</style>
