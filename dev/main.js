/* global $ Vue */
import DefaultPreferences from './components/DefaultPreferences.vue';

$(function () {
    Vue.instantiateEach('#defaultPrefs',
        {
            components: {
                DefaultPreferences,
            },
        }
    );
});
