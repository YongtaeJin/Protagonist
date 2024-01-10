<template>
    <v-form @submit.prevent="save" ref="form" v-model="valid" lazy-validation @@submit.prevent="edit">
        <v-data-table :headers="headers" :items="form"  single-select  item-key="i_shop" :height=iframeHeight hide-default-footer :items-per-page="-1" >
            <template v-slot:item="{ item }">
                <tr :class="{ 'row_select': item === selected}" @click="selectRow(item)" @dblclick="showRowInfo" class="center-align" >
                    <td> {{ item.i_shop }}</td>
                    <td> {{ item.n_shop }}</td>
                    <td> {{ item.d_date1 }}</td>
                    <td> {{ item.d_date1}}</td>
                    <td align="left"> {{ item.t_remark }}</td>
                </tr>
            </template>
        </v-data-table>
    </v-form>
    
</template>

<script>
import { deepCopy } from "../../../util/lib";
export default {
    name: "Shopmag01Form",
    props: {        
        itemLists: {
            type: Array,
            default: null,
        },
        iframeHeight: {type: Number, default: 500,}
    },
    data() {
        return {
            valid: true,
            headers: [
                { text: '신청번호',  value: 'i_shop', sortable: false, width: "100px", fixed: true, align:'center'},
                { text: '사업명', value: 'n_shop', sortable: false, align:'center',  },
                { text: '사업시작', value: 'd_date1', sortable: false, width: "150px", fixed: true, align:'center'}, 
                { text: '사업종료', value: 'd_date2', sortable: false, width: "150px", fixed: true, align:'center'},
                { text: '비고', value: 't_remark', sortable: false, width:"35%", align:'center',}  
            ],
            form: {
                i_shop: "",
                n_shop: "",
                d_date1: "",
                d_date2: "",
                t_remark: "",                
            },
            isSelecting: false,
            selected: [],
        }
    },
    created() {
        this.init();
    },
    watch: {
        itemLists() {
            this.init();
        }
    },
    methods: {
        init() {
            if (this.itemLists) {       
                this.form = deepCopy(this.itemLists);
            } else {

            }
        },
        // async showRowInfo(event, { item }) {            
        //     await this.$emit("edit", item );
        // },
        async showRowInfo() {            
            await this.$emit("edit", this.selected )
        },
        async save() {
            this.$emit("save");
        },
        // async selectRow(event, { index, item }) {             
        //     this.$emit("select", index, item);
        // },
        async selectRow( item ) {
            if (this.selected == item) return;
            this.selected = item;
            this.$emit("select", item);
        }
    }
}
</script>

<style>

</style>