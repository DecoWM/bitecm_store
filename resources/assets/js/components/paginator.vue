<template>
    <ul class="pagination">
      <!-- Previous Page Link -->
      <li v-if="pagination.current_page == 1" class="disabled">
        <span>
          <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        </span>
      </li>
      <li v-if="pagination.current_page > 1">
        <a href="#" rel="prev" v-on:click.prevent="changePage(pagination.current_page - 1)">
          <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        </a>
      </li>

      <!-- Pagination Elements -->
      <li v-for="page in pagesNumber" :class="{'active': page == pagination.current_page}">
        <a href="#" v-on:click.prevent="changePage(page)">{{ page }}</a>
      </li>

      <!-- Next Page Link -->
      <li v-if="pagination.current_page < pagination.last_page">
        <a href="#" aria-label="Next" v-on:click.prevent="changePage(pagination.current_page + 1)">
          <span aria-hidden="true">
            <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
          </span>
        </a>
      </li>
      <li  v-if="pagination.current_page == pagination.last_page" class="disabled">
        <span>
          <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
        </span>
      </li>
    </ul>
</template>

<script>
    export default{
        props: {
            pagination: {
                type: Object,
                required: true
            },
            offset: {
                type: Number,
                default: 4
            }
        },
        computed: {
            pagesNumber: function () {
                if (!this.pagination.to) {
                    return [];
                }
                var from = this.pagination.current_page - this.offset;
                if (from < 1) {
                    from = 1;
                }
                var to = from + (this.offset * 2);
                if (to >= this.pagination.last_page) {
                    to = this.pagination.last_page;
                }
                var pagesArray = [];
                for (from = 1; from <= to; from++) {
                    pagesArray.push(from);
                }
                return pagesArray;
            }
        },
        methods : {
            changePage: function (page) {
                if (this.pagination.current_page != page) {
                    this.$emit('changepage', page)
                }
                // this.pagination.current_page = page;
            }
        }
    }
</script>
