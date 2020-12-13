<template>
  <div>
    <div @click="editing = true" class="card card-content">
      {{ card.name }}
    </div>

    <div v-if="editing" class="modal" @click="closeModal" style="display: block">
      <div class="modal-background"></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Edit {{ card.name }}</p>
          <button class="delete" aria-label="close" @click="editing=false"></button>
        </header>

        <section class="modal-card-body">
          <input class="input" :placeholder="name" v-model="name">
        </section>

        <footer class="modal-card-foot">
          <button class="button is-success" @click="save">Save changes</button>
          <button class="button" @click="editing=false">Cancel</button>
        </footer>
      </div>
    </div>
  </div>
</template>

<script>
import Rails from "rails-ujs";

export default {
  name: "Card",
  props: ['card', 'list'],
  data: function() {
    return {
      editing: false,
      name: this.card.name
    }
  },

  methods: {
    save: function() {
      var data = new FormData;
      data.append("card[name]", this.name);

      Rails.ajax({
        url: `/cards/${this.card.id}`,
        data: data,
        type: 'PATCH',
        dataType: 'json',
        success: (data) => {
          const list_index = window.store.lists.findIndex((item) => item.id === this.list.id);
          const card_index = window.store.lists[list_index].cards.findIndex((item) => item.id === this.card.id);
          window.store.lists[list_index].cards.splice(card_index, 1, data);

          this.editing = false;
        }
      })
    },
    closeModal: function (event) {
      if(event.target.classList.contains("modal-background")) {
        this.editing = false;
      }
    }
  }
}
</script>

<style scoped>
.modal {
  margin: 0 auto;
}

.modal-card {
  top: 25%;
}
</style>