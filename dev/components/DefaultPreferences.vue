<template>
    <div class="flatskin-wrapped">
        <div class="grid-x grid-margin-x">
            <div class="cell auto">
                <label>Filter
                    <input type="text" v-model="filter">
                </label>
            </div>
            <fieldset v-if="!isSitePrefTopic" class="shrink cell">
                <legend>Options</legend>
                <vue-check-item name="sitePreferencesOnly" v-model="showSitePrefsOnlySettings">Include SitePreferences only settings</vue-check-item>
            </fieldset>
        </div>
        <vue-spacer/>
        <preference v-for="pref in filteredPreferences" v-bind:key="pref.name" :preference="pref"></preference>
    </div>
</template>


<script>
import Preference from './Preference.vue';
export default {
    data(){
        return {
            prefs: {},
            filter: "",
            isSitePrefTopic: false,
            showSitePrefsOnlySettings: false,
        };
    },
    components: {
        Preference
    },
    props: ["preferencesSelector"],
    computed: {
        filteredPreferences() {
            let self = this;
            return this.prefs.filter((pref) => {
                // Filter out preferences where the last override happened in site preferences
                // if option to explicitly include them is not set
                if(!self.showSitePrefsOnlySettings && pref.inheritPath[pref.inheritPath.length - 1].source === "Main/SitePreferences"){
                    return false;
                }
                //Filter string is empty -> Include everything
                if(!this.filter)
                    return true;
                let tester = new RegExp(this.filter.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1"), 'gi');
                return tester.test(pref.name) || tester.test(pref.value);
            }).sort((a, b) => {
                return a.name.localeCompare(b.name);
            });
        }
    },
    created() {
        let config = Vue.getConfigById(this.preferencesSelector);
        this.prefs = config.preferences;
        this.isSitePrefTopic = config.isSitePrefTopic;
        this.showSitePrefsOnlySettings = this.isSitePrefTopic;
    }
};
</script>
