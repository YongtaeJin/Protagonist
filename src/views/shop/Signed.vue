<template>
    <v-card v-if="!this.$store.state.user?.member"  width="100%" elevation="10">
        <login />
    </v-card>
    <v-card v-else>
        <v-toolbar background-color="primary" dark>
            <v-toolbar-title>스마트공방 사업신청</v-toolbar-title>
            <v-spacer></v-spacer>
        </v-toolbar>  
        
        <v-card background-color="primary" >            
            <div v-text="memo" style="white-space:pre-line"></div>
        </v-card>
        
        <v-tabs v-model="tabs" background-color="primary" dark>
            <v-tab value="tbapage_1" style="flex: 1" >개인정보 동의</v-tab>
            <v-tab value="tbapage_2" style="flex: 1" :disabled="!istab1">회사 정보</v-tab>
            <v-tab value="tbapage_3" style="flex: 1" :disabled="!this.istab2" >스마트공방 신청</v-tab>
            <v-tab value="tbapage_4" style="flex: 1" :disabled="!this.istab3 || !this.istab2" >회사 추가 정보</v-tab>            
        </v-tabs>
        
        <v-card-text>
            <v-tabs-items v-model="tabs">                                 
                <v-tab-item><signed-p-01-form @save="save1" /></v-tab-item>                
                <v-tab-item><signed-p-02-form @save="save2" :item="this.$store.state.user.shopinfo"/></v-tab-item>
                <v-tab-item><signed-p-03-form @save="save3" :attfile="this.shioinfofiles" :iframeHeight="iframeHeight"/></v-tab-item>
                <v-tab-item><signed-p-04-form @save="save4" :attfile="this.shopinfofileadds" :iframeHeight="iframeHeight"/></v-tab-item>
            </v-tabs-items>            
        </v-card-text>
      
    </v-card>

</template>

<script>
import { mapActions, mapGetters, mapMutations } from "vuex";
import { deepCopy } from "../../../util/lib";
import Login from '../member/Login.vue'
import SignedP01Form from './SignedP01Form.vue'
import SignedP02Form from './SignedP02Form.vue'
import SignedP03Form from './SignedP03Form.vue'
import SignedP04Form from './SignedP04Form.vue'

export default {
  components: { Login, SignedP01Form, SignedP02Form, SignedP03Form, SignedP04Form },

	name :"ShopSigned",
	title : "스마트공방 신청",
    data() {
        return {
            iframeHeight: 500, // 초기 높이 설정 (원하는 높이로 초기화)
            tabs: parseInt(this.$route.query.tabs) || 0 ,
            // items: ["개인정보 동의", "회사 정보", "스마트공방 신청", "회사 추가 정보"],  

            isLoading: false,
            items: [
                {id:'Sucess', name:'개인정보 동의', enable:'Y'},
                {id:'Cominfo', name:'회사 정보', enable:'Y'},
                {id:'Input', name:'스마트공방 신청', enable:'Y'},
                {id:'Addinfo', name:'회사 추가 정보', enable:'Y'},
            ],
            shioinfofiles: [],
            shopinfofileadds: [],                      
            istab2: false,  
            istab3: false,
            istab4: false,
            filechk: { field: "f_gubun", value: "1"},
            memo : "",
        }
    },
    mounted() {
        // 창 크기가 변경될 때마다 iframe의 높이를 조정
        window.addEventListener('resize', this.adjustIframeHeight);
        this.adjustIframeHeight(); // 초기 조정 
        window.addEventListener('beforeunload', this.leave);
        if (this.$store.state.user.member ) {
            this.fetchData();            
            if(this.$store.state.user.shopinfo?.f_persioninfo) {
               this.tabs = 1;
            } else {
                this.tabs = 0;
            }
        }

    },
    beforeUnmount() {
        window.removeEventListener('beforeunload', this.leave)
    },
    beforeDestroy() {
        // 컴포넌트가 파기될 때 리스너 제거
        window.removeEventListener('resize', this.adjustIframeHeight);
    },
    computed: {
        istab1() {
            if (this.$store.state.user.shopinfo?.f_persioninfo == '1' ) {
                return true;
            } 
            return false;
        },
    },
    methods: {
        ...mapActions("user", ["checkShopInfo", "updateShopInfo"]),        
        ...mapMutations("user", ["SET_SHOPINFO"]),
        ...mapGetters("user", ["isShopinfochk"]),
        adjustIframeHeight() {
        // 브라우저 창의 높이를 iframe의 높이로 설정
            const windowHeight = window.innerHeight;
            this.iframeHeight = windowHeight - 360;
        },
        leave(event) {
		    event.preventDefault();
		    event.returnValue = '';
	    },
        inputFileChk() {
            this.istab3 = true;
            if (this.shioinfofiles) {
                for(let ob in this.shioinfofiles) {                    
                    if (this.shioinfofiles[ob].f_yn == '1' && !this.shioinfofiles[ob].t_att) {
                        this.istab3 = false;
                        return;
                    }                    
            	}
            }
        },

        async fetchData() {       
            const data = await this.checkShopInfo();  
            // console.log(this.$store.state.user.shopinfo?.i_shop)          
            this.shioinfofiles = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=1`);
            this.shopinfofileadds = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=2`);
            if (this.$store.state.user.shopinfo) { this.istab2 = await this.isShopinfochk(); }
            this.inputFileChk();
            this.memo = this.$store.state.user.shopinfo?.t_remark;
        },        
        async save1(form) {
            if (!form.i_shop) {
                form.i_shop = this.$store.state.user.shopinfo.i_shop;
                form.i_userid = this.$store.state.user.shopinfo.i_userid;
            }           
            const data = await this.updateShopInfo(form);
            if ( data ) {                
                this.shioinfofiles = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=1`);
                this.shopinfofileadds = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=2`);
                await this.checkShopInfo();
                this.istab2 = await this.isShopinfochk()
                this.$toast.info(`개인정보 동의 하였습니다.`);                            
            }
        },
        async save2(form) {
            const data = await this.updateShopInfo(form);
            if ( data ) {
                await this.checkShopInfo(); 
                this.istab2 = await this.isShopinfochk()
                this.$toast.info(`회사 정보 저장 하였습니다.`);                   
            }
        },
        async save3(form) {
            await this.$axios.patch(`/api/shopinfo/attfiles/upload`, form);
            this.shioinfofiles = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=1`);
            this.$toast.info(`스마트공방 신청 저장 하였습니다.`);  
            this.inputFileChk();
        },
        async save4(form) {
            await this.$axios.patch(`/api/shopinfo/attfiles/upload`, form);
            this.shopinfofileadds = await this.$axios.patch(`/api/shopinfo/attfiles?i_shop=${this.$store.state.user.shopinfo?.i_shop}&f_gubun=2`);
            this.$toast.info(`회사 추가 정보 저장 하였습니다.`);  
        },

    }
}
</script>

<style>
</style>