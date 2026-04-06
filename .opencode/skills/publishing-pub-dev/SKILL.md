---
name: publishing-pub-dev
description: Use when publishing a Dart package to pub.dev. Handles version bumping, CHANGELOG updates, git tagging, verification, and publishing. Triggers after implementation cycles complete or when user requests deployment.
---

# Publishing to pub.dev

## Overview

버전 업 → CHANGELOG → 검증 → 커밋 → 태그 → 푸시 → 배포 파이프라인.

**Core principle:** 모든 단계가 자동화되어야 하며, dry-run 경고가 0일 때만 배포한다.

## When to Use

- continuous-improvement 루프 5회마다 자동 배포 시점
- 사용자가 "publish", "deploy", "배포"라고 명시할 때
- finishing-a-development-branch 이후 배포가 필요할 때

## Pre-flight Checklist

```bash
dart analyze                              # 0 issues
dart format --set-exit-if-changed .       # 0 changes
dart test                                 # all pass
git status --porcelain                    # empty
```

**모든 항목 통과 시에만 진행. 실패 시 수정 후 처음부터 재시도.**

## Version Bump Rules

| 조건 | Bump | 예시 |
|------|------|------|
| 리팩토링, dartdoc, 버그 수정, 문서 | patch | 0.0.2 → 0.0.3 |
| 새 위젯, 새 기능 | minor | 0.0.x → 0.1.0 |
| Breaking API 변경 | major | 0.x → 1.0.0 |
| continuous-improvement 5루프 누적 | patch | 자동 |

## Steps

### 1. Version Bump

`pubspec.yaml`의 `version` 필드를 업데이트.

### 2. CHANGELOG Update

`CHANGELOG.md` 최상단에 새 항목 추가:

```markdown
## X.Y.Z (YYYY-MM-DD)

- 변경 내용 1
- 변경 내용 2
```

항목은 backlog.md의 마지막 N루프 completed 항목에서 추출.

### 3. Dry-run Verification

```bash
dart pub publish --dry-run 2>&1 | tail -5
```

**0 warnings** 확인. warnings 있으면 수정 후 Step 1부터 재시도.

### 4. Commit & Tag

```bash
git add -A
git commit -m "chore: publish vX.Y.Z"
git tag vX.Y.Z
```

### 5. Push

```bash
git push origin main --tags
```

### 6. Publish

```bash
dart pub publish --force
```

### 7. Verify

```bash
curl -s https://pub.dev/api/packages/radartui | grep '"version"'
```

## Error Recovery

| 상황 | 대응 |
|------|------|
| dry-run warnings | 원인 수정 → patch bump → Step 1부터 재시도 |
| publish 실패 (네트워크) | 재시도 |
| publish 실패 (검증) | 원인 수정 → patch bump → Step 1부터 재시도 |
| 태그 이미 존재 | `git tag -d vX.Y.Z && git push origin :refs/tags/vX.Y.Z` 후 재생성 |
| pub.dev 로그인 안됨 | `dart pub login` 안내 후 중단 |

## Red Flags

- dry-run 경고를 무시하고 배포 금지
- 태그 없이 배포 금지 (repository 검증 실패 원인)
- GitHub push 없이 배포 금지 (repository 검증 실패 원인)
- `dart analyze` 경과가 0 issues가 아닌데 배포 금지

## Quick Reference

```
pre-flight → version bump → changelog → dry-run → commit → tag → push → publish → verify
```
