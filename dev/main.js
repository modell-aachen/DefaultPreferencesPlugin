/* global $ Vue */
import DefaultPreferences from './components/DefaultPreferences.vue';

$( function () {
    Vue.instantiateEach(
        '.DefaultPrefsContainer',
        { components: { DefaultPreferences } }
    );
});
