module.exports = {
    moduleFileExtensions: [
        'js',
        'jsx',
        'json',
        'vue',
    ],
    transform: {
        '.*\\.(vue)$': 'vue-jest',
        '.+\\.(css|styl|less|sass|scss|svg|png|jpg|ttf|woff|woff2)$': 'jest-transform-stub',
        '^.+\\.jsx?$': 'babel-jest',
    },
    moduleNameMapper: {
        '^@/(.*)$': '<rootDir>/src/$1',
        '\\.(css|less)$': 'identity-obj-proxy',
    },
    testMatch: [
        '**/frontend-tests/**/*.spec.(js|jsx)|**/__tests__/*.(js|jsx)',
    ],
    transformIgnorePatterns: [
        '/node_modules/',
    ],
    collectCoverageFrom: [
        'dev/**/*.{js,vue}',
        '!**/node_modules/**',
    ],
    coverageReporters: ['lcov', 'text-summary'],
    testURL: 'http://localhost/',
};
