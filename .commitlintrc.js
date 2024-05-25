module.exports = {
  rules: {
    "type-enum": [
      2,
      "always",
      [
        "build",
        "chore",
        "ci",
        "docs",
        "feat",
        "fix",
        "perf",
        "refactor",
        "revert",
        "style",
        "test",
      ],
    ],
    "scope-empty": [0],
    "subject-empty": [2, "never"],
    "subject-case": [0],
    "header-max-length": [0],
  },
  parserPreset: {
    parserOpts: {
      headerPattern: /^(\w+)(?:\(([^)]+)\))?: (.+)$/,
      headerCorrespondence: ["type", "scope", "subject"],
    },
  },
};
