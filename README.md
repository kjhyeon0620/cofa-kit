# cofa-kit

AI 코딩 에이전트(Codex, Claude Code 등)와 **Spec-Driven으로 일하는 경량 키트**입니다.
코드는 들어 있지 않고, 일하는 순서와 기록 양식만 들어 있습니다. 개인 프로젝트, 해커톤, 시간 제한 과제에 그대로 붙여 쓸 수 있습니다.

팀 저장소에서 쓰던 SDD 절차를 혼자, 짧게 일할 때에 맞게 줄였습니다.
- 스펙 상태 `draft → ready → in-progress → done`. ready 전에는 구현하지 않음
- 미결 질문은 한 번에 5개, 최대 2라운드. 모르는 건 기본값으로 가정하고 기록
- Decisions 기록, 구현 재량과 범위 변경의 구분
- Task마다 "먼저 읽을 것 / 변경 / 금지 / 검증"
- 완료 증거 표, 알려진 격차, 회고
- 규칙 중 확인할 수 있는 것은 `scripts/check.sh`로 강제

## 구성
```
AGENTS.md              에이전트 규칙 (먼저 읽을 것, SDD 규칙, Git, 코드 규칙, 보고 형식)
docs/process.md        절차의 단일 기준 (흐름, 질문 규칙, 유형별 순서, 검증, 마무리)
docs/spec.md           이번 작업의 스펙 (빈 양식, status: draft로 시작)
docs/handoff.md        현재 상태 인계
docs/profiles/         상황별 추가 규칙
  timed.md             시간 제한 과제: 시간표, 제한 환경 규칙, 제출·사후 질의
scripts/check.sh       커밋 전 점검 (스펙 상태, Open 질문, Decisions, 완료 증거, 알려진 격차, 테스트)
```

## 사용법
```bash
git clone https://github.com/kjhyeon0620/cofa-kit.git /tmp/kit
cp -Rn /tmp/kit/{AGENTS.md,docs,scripts} .
```
`-n`은 같은 이름의 기존 파일을 덮어쓰지 않습니다. 이미 `AGENTS.md`가 있으면 직접 합치세요.

그다음 에이전트에게:
> AGENTS.md와 docs/process.md를 읽어. 요구사항은 <위치>에 있어. docs/spec.md 초안을 쓰고, 내가 물어볼 Open 질문을 최대 5개 뽑아줘.

시간 제한 과제라면 첫 문장을 "AGENTS.md, docs/process.md, docs/profiles/timed.md를 읽어"로 바꿉니다.

## 처음 10분
1. 요구사항과 자료 목록 읽기 (만들기 전에)
2. 키트 복사, `git init` (이미 저장소면 생략), 키트와 자료를 첫 커밋으로
3. 에이전트에게 스펙 초안과 Open 질문 요청
4. 질문 → 답을 Decisions에 기록 → `status: ready` → 커밋
