<template>
<div class="expanded row">
<div class="shrink column"><button ref="copy-button" class="tiny button" v-bind:data-clipboard-text="clipboardText"><i class="fa fa-clipboard" aria-hidden="true"></i></button></div>
<div class="column">
<ul ref="list" class="menu vertical" style="list-style-image: none; padding-left: 0px;">
<li>
        <a href="#">Set {{preference.name}} = {{preference.value}}</a>
        <ul class="menu vertical nested">
            <li v-for="(path, index) in preference.inheritPath">
                <span>Set {{preference.name}} = {{path.value}}</span>
                <div class="pref-path">
                    <template v-if="path.isDefaultPref">({{path.source}})</template>
                    <a v-else v-bind:href="'/'+path.source">({{path.source}})</a>
                <div>
            </li>
        </ul>
</li>
</ul>
</div>
</div>
</template>

<script>
/* global $ Foundation */
import Clipboard from "clipboard";
export default {
    props: ["preference"],
    computed: {
        clipboardText(){
            return `* Set ${this.preference.name} = ${this.preference.value}`;
        }
    },
    mounted() {
        new Foundation.AccordionMenu($(this.$refs['list']));
        new Clipboard(this.$refs['copy-button']);
    }
};
</script>
<style lang="sass">
.pref-path, .pref-path :link {
    font-size: 12px;
}
</style>