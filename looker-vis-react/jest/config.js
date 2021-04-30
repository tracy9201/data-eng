module.exports = {
  rootDir: '../',
  roots: ['<rootDir>/src/components'],
  transform: {
    '\\.js$': ['babel-jest', { configFile: './jest/babel.config.js' }],
  },
  moduleNameMapper: {
    '^@utils(.*)$': '<rootDir>/src/utils$1',
    '^@components(.*)$': '<rootDir>/src/components$1',
    '^.+\\.(css|scss)$': '<rootDir>/jest/no-op.js',
  },
  collectCoverageFrom: [
    '<rootDir>/src/**/*.js',
    '!<rootDir>/src/test-utils/**/*.js',
  ],
  coverageDirectory: '<rootDir>/jest/coverage',
  setupFilesAfterEnv: ['<rootDir>/jest/setup.js'],
}
