<template>
 	<v-app>
		<v-navigation-drawer v-if="this.$store.state.user.member"  app v-model="drawer" :width="drawerWidth" disable-resize-watcher >
			<site-navi  @close="toggleDrawer"/>
		</v-navigation-drawer>

    	<v-app-bar app color="primary" dark hide-on-scroll>
			<v-app-bar-nav-icon @click="toggleDrawer" />
			<site-title />
			<v-spacer></v-spacer> 
			<site-user />
		</v-app-bar>
		
    	<v-main>			 
    		<router-view />			 
    	</v-main>
		
		<site-footer />
    	<vue-progress-bar></vue-progress-bar>
	</v-app>
</template>

<script>
import { mapActions, mapMutations } from "vuex";

import SiteFooter from './components/layout/SiteFooter.vue';
import SiteTitle from './components/layout/SiteTitle.vue';
import SiteNavi from "./components/layout/SiteNavi.vue";
import SiteUser from './components/layout/SiteUser.vue';

export default {
  components: { SiteTitle, SiteFooter, SiteNavi, SiteUser },
  name: "App",

  data() {
		return {
			drawer : true,
			loginchk : false,
		}
	},
	serverPrefetch() {		
		return new Promise((resolve, reject)=>{
			resolve();
		});
	},
	beforeCreate() {
		
	},
	created() {
		
	},
	beforeMount() {
		
	},
	mounted() {
		
	},

	computed : {
		drawerWidth() {
			return this.$vuetify.breakpoint.xs ? '100%' : '300';
		}
	},
	methods : {		
		toggleDrawer() {
			this.drawer = !this.drawer;
		}
		
	}
};
</script>

<style>
.mytable table th {
    /* background-color: lightgoldenrodyellow; */	
	background-color: #D4F755;
    border-bottom: none !important;
 }
 
.v-data-table > .v-data-table__wrapper > table > tbody > tr > th, .v-data-table > .v-data-table__wrapper > table > thead > tr > th, .v-data-table > .v-data-table__wrapper > table > tfoot > tr > th 
{
	font-size: 1.00rem;
    height: 35px;    
}
.v-data-table > .v-data-table__wrapper > table > tbody > tr > td, .v-data-table > .v-data-table__wrapper > table > thead > tr > td, .v-data-table > .v-data-table__wrapper > table > tfoot > tr > td {
  font-size: 0.35rem;
  height: 26px; 
}

</style>