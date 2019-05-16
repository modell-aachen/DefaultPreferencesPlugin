<template>
    <div class="grid-x grid-margin-x">
        <div class="cell shrink">
            <vue-button
                ref="copy-button"
                v-tooltip="{
                    content: tooltipText,
                    show: tooltipVisible,
                    trigger: 'manual',
                    placement: 'bottom-center',
                    classes: 'flatskin-wrapped v-tooltip-success'}"
                type="icon"
                icon="fas fa-clipboard"
                no-margins
                @click.native="copySetting" />
            <vue-spacer />
        </div>
        <div class="cell auto">
            <a href="#">Set {{ preference.name }} = {{ preference.value }}</a>
            <i
                :class="chevronByCollapsed"
                class="ma-dark-grey-color fas fa-fw"
                @click="toggleCollapsed" />
            <vue-slide-up-down
                :active="!collapsed"
                :duration="300">
                <ul class="menu vertical nested">
                    <li
                        v-for="path in preference.inheritPath"
                        :key="path.source">
                        <span>Set {{ preference.name }} = {{ path.value }}</span>
                        <div class="pref-path">
                            <template v-if="path.isDefaultPref">
                                ({{ path.source }})
                            </template>
                            <a
                                v-else
                                :href="'/'+path.source">({{ path.source }})</a>
                        </div>
                    </li>
                </ul>
            </vue-slide-up-down>
        </div>
    </div>
</template>

<script>
/* global window */
export default {
    props: {
        preference: {
            type: Object,
            required: true,
        },
    },
    data() {
        return {
            collapsed: true,
            copySuccessText: 'Copied to clipboard!',
            copyErrorText: 'Error',
            tooltipVisible: false,
            tooltipText: '',
        };
    },
    computed: {
        clipboardText() {
            return `   * Set ${this.preference.name} = ${this.preference.value}`;
        },
        chevronByCollapsed() {
            return this.collapsed ? 'fa-chevron-right' : 'fa-chevron-down';
        },
    },
    methods: {
        toggleCollapsed() {
            this.collapsed = !this.collapsed;
        },
        showTooltip: function(state) {
            this.tooltipText = this.$data[`copy${state}Text`];
            this.tooltipClass = 'flatskin-wrapped v-tooltip-' + state;
            this.tooltipVisible = true;
            window.setTimeout(() => {
                this.tooltipVisible = false;
            }, 2000);
        },
        async copySetting() {
            try {
                await this.$copyText(this.clipboardText);
            } catch (err) {
                this.showTooltip('Error');
            }
            this.showTooltip('Success');
        },
    },
};
</script>
<style lang="scss">
.pref-path, .pref-path :link {
    font-size: 12px;
}
</style>
