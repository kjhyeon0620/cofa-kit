# cofa-kit

AI 코딩 에이전트(Codex 등)와 시간 제한 있는 실무형 과제를 풀 때 쓰는 Spec-Driven 작업 키트입니다.
과제 풀이 코드는 들어 있지 않고, **일하는 순서와 기록 양식**만 들어 있습니다.

평소 프로젝트에서 쓰던 SDD 절차를 180분 과제에 맞게 줄였습니다.
스펙 상태(`draft → ready → done`), 미결 질문은 한 번에 5개까지, Decisions 기록, 구현 재량과 범위 변경의 구분, 완료 증거 표, Task별 "먼저 읽을 것 / 변경 / 금지 / 검증", 회고.

## 구성
```
AGENTS.md          에이전트 규칙 (먼저 읽을 것, SDD 규칙, Git, 코드 규칙, 보고 형식)
docs/process.md    절차의 단일 기준 (시간표, 질문 규칙, 유형별 순서, 검증, 마무리)
docs/spec.md       이번 과제의 스펙 (빈 양식, status: draft로 시작)
docs/handoff.md    현재 상태 인계
scripts/check.sh   커밋 전 점검 (스펙 상태, Open 질문, Decisions, 완료 증거, 알려진 격차, 테스트)
```

## 사용법
```bash
git clone https://github.com/kjhyeon0620/cofa-kit.git /tmp/kit
cp -Rn /tmp/kit/{AGENTS.md,docs,scripts} .
```
`-n`은 과제가 준 같은 이름의 파일을 덮어쓰지 않습니다. 과제에 이미 `AGENTS.md`가 있으면 직접 합치세요.
시험 환경은 개인 PC 파일 업로드가 안 되므로, 키트는 공개 저장소에서 `git clone`으로만 가져올 수 있습니다.

## 사전 체험(15분)에서 확인할 것
1. `git clone`으로 이 저장소를 받을 수 있는가
2. `codex` 실행 후 `/status`로 모델·권한 확인, AGENTS.md를 읽는지 ("AGENTS.md 요약해줘")
3. `python3 --version`, `python3 -m pytest --version`, `bash scripts/check.sh` 실행
4. 터미널 탭 나누기, 에디터 저장 상태, 서버를 `0.0.0.0`으로 띄워 미리보기 열기
그다음 에이전트에게:
> AGENTS.md와 docs/process.md를 읽어. 과제 설명은 <위치>에 있어. docs/spec.md 초안을 쓰고, 내가 실무자에게 물어볼 Open 질문을 최대 5개 뽑아줘.

## 처음 10분
1. 과제 설명과 자료 목록 읽기 (만들기 전에)
2. 위 명령으로 키트 복사, `git init` (이미 저장소면 생략)
3. 에이전트에게 스펙 초안과 Open 질문 요청
4. 실무자에게 질문 → 답을 Decisions에 기록 → `status: ready` → 커밋
