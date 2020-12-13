<template>
  <draggable :list="lists" :options="{group: 'lists'}" class="columns dragArea board" @end="listMoved">
    <div v-for="(list, index) in original_lists" class="column is-3 list">
      <h6 class="title is-6">{{ list.name }}</h6>

      <draggable v-model="list.cards" :options="{group: 'cards'}" class="dragArea" @change="cardMoved">
        <div v-for="(card, index) in list.cards" class="card card-content">
          {{ card.name }}
        </div>
      </draggable>

      <div class="card-footer">
        <textarea v-model="messages[list.id]" class="textarea" rows="2" placeholder="New item"></textarea>

        <button @click="submitMessages(list.id)" class="button is-primary">Add</button>
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
    cardMoved: function (event) {
      const evt = event.added || event.moved;
      if(evt === undefined) { return }

      const element = evt.element;

      const list_index = this.lists.findIndex((list) => {
        return list.cards.find((card) => {
          return card.id === element.id;
        });
      });

      var data = new FormData;
      data.append("card[list_id]", this.lists[list_index].id);
      data.append("card[position]", evt.newIndex + 1);

      Rails.ajax({
        url: `/cards/${element.id}/move`,
        type: 'PATCH',
        data: data,
        dataType: 'json'
      })
    },

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
  min-height: 10px;
}
</style>
