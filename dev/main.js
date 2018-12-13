/* global $ Vue */
import DefaultPreferences from './components/DefaultPreferences.vue';
import VueClipboard from 'vue-clipboard2';

$( function () {
    Vue.use(VueClipboard);
    new Vue({
        el: '#defaultPrefs',
        components: {
            DefaultPreferences
        }
    });
});
