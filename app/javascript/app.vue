<template>
  <draggable :list="lists" :options="{group: 'lists'}" class="columns dragArea board" @end="listMoved">
    <List v-for="(list, index) in lists" :list="list" />

    <div class="column is-3 list new-list">
      <div class="card-footer">
        <textarea v-if="editing" v-model="message" ref="message" class="textarea" rows="2" placeholder="New item"></textarea>
        <button  v-if="editing" @click="createList" class="button is-primary">Add</button>
        <a v-if="!editing" v-on:click="startEditing" >Add a list</a>
        <a v-if="editing" v-on:click="editing=false" class="cancel-button">Cancel</a>
      </div>
    </div>
  </draggable>
</template>

<script>
import Rails from 'rails-ujs';
import draggable from 'vuedraggable';

import List from 'components/List';

export default {
  components: { draggable, List },
  data: function () {
    return {
      editing: false,
      message: ""
    }
  },
  computed: {
    lists() {
      console.log(this.$store.state.lists);
      return this.$store.state.lists;
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
    startEditing: function() {
      this.editing = true;
      this.$nextTick(() => {this.$refs.message.focus() })
    },
    createList: function() {
      var data = new FormData;
      data.append("list[name]", this.message);
      Rails.ajax({
        url: '/lists',
        type: "POST",
        data: data,
        dataType: 'json',
        success: (data) => {
          this.message = "";
          this.editing = false;
        }
      })
    },
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 10px;
}

.columns {
  margin-left: 0;
}
</style>
