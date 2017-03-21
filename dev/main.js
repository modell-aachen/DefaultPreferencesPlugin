/* global $ Vue */
import DefaultPreferences from './components/DefaultPreferences.vue';


$( function () {
    new Vue({
        el: '#defaultPrefs',
        components: {
            DefaultPreferences
        }
    });
});
