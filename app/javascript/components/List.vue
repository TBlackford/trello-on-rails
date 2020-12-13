<template>
  <div class="column is-3 list">
    <h6 class="title is-6">{{ list.name }}</h6>

    <draggable v-model="list.cards" :options="{group: 'cards'}" class="dragArea" @change="cardMoved">
      <div v-for="(card, index) in list.cards" class="card card-content">
        {{ card.name }}
      </div>
    </draggable>

    <div class="card-footer">
      <textarea v-if="editing" v-model="message" ref="message" class="textarea" rows="2" placeholder="New item"></textarea>
      <button  v-if="editing" @click="submitMessage" class="button is-primary">Add</button>
      <a v-if="!editing" v-on:click="startEditing" >Add a card</a>
      <a v-if="editing" v-on:click="editing=false" class="cancel-button">Cancel</a>
    </div>
  </div>
</template>

<script>

import draggable from 'vuedraggable';
import Rails from "rails-ujs";

export default {
  name: "List",
  props: ['list'],
  components: { draggable },
  data: function () {
    return {
      editing: false,
      message: ""
    }
  },
  methods: {
    startEditing: function() {
      this.editing = true;
      this.$nextTick(() => {this.$refs.message.focus() })
    },
    submitMessage: function() {
      var data = new FormData;
      data.append("card[list_id]", this.list.id);
      data.append("card[name]", this.message);
      Rails.ajax({
        url: '/cards',
        type: "POST",
        data: data,
        dataType: 'json',
        success: (data) => {
          const index = window.store.lists.findIndex(item => item.id == this.list.id);
          window.store.lists[index].cards.push(data);
          this.message = "";
        }
      })
    },

    cardMoved: function (event) {
      const evt = event.added || event.moved;
      if(evt === undefined) { return }

      const element = evt.element;

      const list_index = window.store.lists.findIndex((list) => {
        return list.cards.find((card) => {
          return card.id === element.id;
        });
      });

      var data = new FormData;
      data.append("card[list_id]", window.store.lists[list_index].id);
      data.append("card[position]", evt.newIndex + 1);

      Rails.ajax({
        url: `/cards/${element.id}/move`,
        type: 'PATCH',
        data: data,
        dataType: 'json'
      })
    },
  }
}
</script>

<style scoped>
.cancel-button {
  margin-top: 15px;
  display: inline-flex;
}
</style>