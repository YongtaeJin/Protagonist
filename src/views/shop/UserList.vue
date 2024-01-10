<template>
    <v-form  ref="form">
        <v-toolbar background-color="primary" dark >
            <v-spacer/>
            <v-text-field label="ID/이름/email : " v-model="f_serarch" hide-details  single-lin  />            
            <v-btn color="primary"  @click="fetchData">조회</v-btn>
        </v-toolbar>
        
        <v-data-table :headers="headers" :height=iframeHeight hide-default-footer :items-per-page="-1" 
            :items="items" single-select  item-key="mb_id" >
            <template v-slot:item="{ item }">
                <tr :class="{ 'row_select': item === selected}" @click="selectItem(item)" class="center-align" >
                    <td>{{ item.mb_id }}</td>
                    <td>{{ item.mb_name }}</td>
                    <td align="left">{{ item.mb_email }}</td>
                    <td @dblclick="levleChange(item)"><u>{{ item.mb_level }}</u></td>
                    <td>{{ item.chkpw }}</td>
                    <td @dblclick="use_delete(item)"><u>삭제</u> </td>
                </tr>
            </template>

        </v-data-table>
            
        
    </v-form>
</template>

<script>
import { id } from '../../../util/validateRules';
export default {
    name :"UserList",
	title : "사용자정보",
    data() {
        return {
            iframeHeight: 500, // 초기 높이 설정 (원하는 높이로 초기화)
            headers: [
                { text: 'ID',  value: 'mb_id', sortable: false, align:'center', width:"20%"},
                { text: '이름',  value: 'mb_name', sortable: false, align:'center', width:"25%"},
                { text: 'email',  value: 'mb_email', sortable: false, align:'center', width:"25%"},
                { text: '등급',  value: 'mb_level', sortable: false, align:'center', width:"10%"},
                { text: '비빌먼호',  value: 'chkpw', sortable: false, align:'center', width:"10%"},
                { text: '사용자삭제', value: 'f_del', sortable: false, align:'center', width:"10%"},
                
            ],
            items: [], selected: [],
            f_serarch: "",
        }
    },
    beforeCreate() {
    },
    created() {
        this.fetchData() ;
    },
    mounted() {
        // 창 크기가 변경될 때마다 iframe의 높이를 조정
        window.addEventListener('resize', this.adjustIframeHeight);
        this.adjustIframeHeight(); // 초기 조정 
        window.addEventListener('beforeunload', this.leave)
    },
    
    beforeUnmount() {
        window.removeEventListener('beforeunload', this.leave)
    },
    beforeDestroy() {
        // 컴포넌트가 파기될 때 리스너 제거
        window.removeEventListener('resize', this.adjustIframeHeight);
    },
    methods: {
        leave(event) {
		    event.preventDefault();
		    event.returnValue = '';
	    },
        adjustIframeHeight() {
        // 브라우저 창의 높이를 iframe의 높이로 설정
            const windowHeight = window.innerHeight;
            this.iframeHeight = windowHeight - 212;           
        },
        async fetchData(){
            this.items = await this.$axios.get(`/api/shopinfo/getShopUserList?f_serarch=${this.f_serarch}`);
        },
        async levleChange(item) {
            let lev = item.mb_level=="관리자"?'일반':'관리자';
            const res = await this.$ezNotify.confirm(`${item.mb_name} 등급 변경 하시겠습니까 ?`, lev);
            if(res) {
                const data = await this.$axios.patch(`/api/shopinfo/patchShopUserList?mb_id=${item.mb_id}&mb_level=${item.mb_level}`);
                if (data.changedRows === 1) {
                    item.mb_level = lev;
                }
            }
        },
        async use_delete(item) {
             const res = await this.$ezNotify.confirm(`${item.mb_name} 삭제 하시겠습니까 ?`, '회사삭제');
             if(res) {
                const data = await this.$axios.patch(`/api/shopinfo/patchShopUserDelete?mb_id=${item.mb_id}&mb_level=${item.mb_level}`);
                if (data.affectedRows === 1) {
                    await this.$ezNotify.confirm("삭제 완료 !!!!!!", "");
                    const idx = this.items.indexOf(item);
                    if (idx) {
                        this.items.splice(idx, 1);
                    }
                }
            }
        },
        selectItem(item) {
            if (this.selected == item) return;
            this.selected = item;

        },
    }
}
</script>

<style>

</style>