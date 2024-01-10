<template>
    <v-card v-if="!this.$store.state.user.member"  width="100%" elevation="10">
        <login />
    </v-card>
    <v-card v-else>
        <v-card v-if="!chk" class="d-flex justify-center align-center" :height="500">
            <p style="font-size:200%">
                서류 심사 중 입니다 ...
            </p>
        </v-card>
        <v-card v-else>
            <v-toolbar>
                <v-toolbar-title>스마트공방 협약신청</v-toolbar-title>
                <v-spacer></v-spacer>
            </v-toolbar>  
            <v-card background-color="primary" dark>
                <div v-text="memo" style="white-space:pre-line"></div>
            </v-card>
            <signed-p-03-form @save="save3" :attfile="this.shioinfofiles" :iframeHeight="iframeHeight"/>
        </v-card>
    </v-card>
</template>

<script>
import { mapActions, mapGetters, mapMutations } from "vuex";
import SignedP03Form from './SignedP03Form.vue'
export default {
    components: { SignedP03Form },
    name :"ShopArgee",
	title : "협약신청",
    data() {
        return {
            iframeHeight: 500, // 초기 높이 설정 (원하는 높이로 초기화)
            shioinfofiles: [],
            memo: "",
            chk: 0,
        }
    },
    created() {
        this.init();
        this.fetchData();
    },
    mounted() {
        // 창 크기가 변경될 때마다 iframe의 높이를 조정
        window.addEventListener('resize', this.adjustIframeHeight);
        this.adjustIframeHeight(); // 초기 조정 
    },
    beforeDestroy() {
        // 컴포넌트가 파기될 때 리스너 제거
        window.removeEventListener('resize', this.adjustIframeHeight);
    },
    methods: {
        ...mapActions("user", ["checkShopInfo"]),    
        ...mapMutations("user", ["SET_SHOPINFO"]),        
        ...mapGetters("user", ["isShopinfochk"]),

        adjustIframeHeight() {
        // 브라우저 창의 높이를 iframe의 높이로 설정
            const windowHeight = window.innerHeight;
            this.iframeHeight = windowHeight - 360;
        },
        async init() {
            const data = await this.checkShopInfo(); 
            this.memo = this.$store.state.user.shopinfo?.t_remark2;
            const chk = await this.$axios.get(`/api/shopinfo/getShopArgeeInChk?i_shop=${this.$store.state.user.shopinfo.i_shop}`);
            if (chk.cnt) this.chk = chk.cnt;
        },
        async fetchData() {
            this.shioinfofiles = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=3`);   

        },
        async save3(form) {
            await this.$axios.patch(`/api/shopinfo/attfiles/upload`, form);
            this.shioinfofiles = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=3`);
            this.$toast.info(`저장 하였습니다.`);              
        },
    }
}
</script>

<style>

</style>