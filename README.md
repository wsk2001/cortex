# Cortex

AI를 위한 코텍스 - 메모리, 라우팅, 계획 기능을 통해 매 세션마다 처음부터 다시 시작하지 않도록 합니다.

Claude Code, Cursor, Copilot, Windsurf와 같은 AI 코딩 도구는 세션 간에 메모리를 유지하지 않습니다. 새로운 대화가 시작될 때마다 프로젝트에 대한 정보가 전혀 없는 상태입니다. 일반적인 50개 파일 규모의 코드베이스에서 AI는 유용한 작업을 시작하기 전에 프로젝트 구조를 탐색하는 데만 25,000 ~ 50,000 토큰을 소비합니다. 즉, 세션 시간의 80 ~ 90%를 구축이 아닌 재적응에 허비하는 것입니다.

코텍스는 AI가 매 세션 시작 시 읽을 구조화된 컨텍스트 파일 세트를 프로젝트에 제공합니다. 탐색하는 대신, 미리 컴파일된 약 2,000 토큰의 컨텍스트를 읽고 즉시 작업에 착수합니다.

## 이 글은 누구를 위한 것인가

이 글은 AI 지원을 받아 앱을 만드는 누구나 어떤 단계에서든 참조 하면 됩니다:

- **아이디어에서 시작하세요.** 아이디어는 있지만 아직 코드는 없습니다. AI가 앱에 대한 인터뷰를 진행하고, 제품 사양을 작성하며, 프로젝트 구조를 설정합니다. 따라서 단 한 번의 세션으로 아이디어에서 체계적인 코드베이스까지 완성할 수 있습니다.
- **개발 중간 단계.** 코드는 정상적으로 작동하지만, AI가 세션 간에 컨텍스트를 잃어버리거나, 잘못된 파일을 열거나, 이미 시도했던 방법을 다시 제안하는 등의 문제가 발생합니다. 이 파일들은 AI에게 현재 위치와 결정된 사항을 정확하게 알려줍니다.
- **실제 앱 배포 시** 코드베이스가 너무 커서 AI가 모든 컨텍스트를 파악할 수 없습니다. 라우팅 테이블과 아키텍처 맵을 통해 AI는 필요한 파일로 즉시 이동하여 토큰 사용량을 줄이고 오류를 최소화할 수 있습니다.

모바일 앱 개발에 최적화되어 있습니다. 웹, 백엔드, 크로스 플랫폼 등 모든 스택에서 작동합니다.

<span style="color: blue">Linux 환경 에서는 잘 동작 하는것을 확인 하였으나, Windows 환경 에서는 설치가 되지 않는다. 설치 스크립트 보완이 필요함.</span>

## 이 방법이 효과적인 이유

AI를 활용하여 개발할 때는 사실상 AI가 엔지니어링 팀 역할을 하는 1인 기업을 운영하는 것과 같습니다. 문제는 팀에 축적된 경험이 없다는 것입니다. 매번 개발 세션을 처음부터 다시 시작해야 합니다.

기업들은 조직 인프라를 통해 이 문제를 해결합니다. Cortex는 AI가 활용할 수 있도록 형식을 갖춘 동일한 구조를 제공합니다.

| 회사 보유 자산 | 제공 혜택 | 목적 |
|---|---|---|
| 제품 사양서 | `docs/PRD.md` | 개발 현황, 향후 개발 계획, 범위 외 개발 사항 추적 |
| 아키텍처 문서 | `docs/APP_ARCHITECTURE.md` | 모든 파일을 매핑하여 AI가 스캔 없이 필요한 파일을 찾을 수 있도록 함 |
| 의사 결정 기록 | `docs/DECISION_LOG.md` | 현재 상황의 이유 기록 |
| 온보딩 문서 | `CLAUDE.md` | AI에 프로젝트 전체 컨텍스트를 단 몇 초 만에 제공 |
| QA 프로세스 | 테스트 규칙 | AI가 출시 전 테스트 제안 |

이는 여러분 자신의 기억을 저장하는 역할도 합니다. 3주 후에는 왜 특정 접근 방식을 선택했는지 기억하지 못할 것이고, 6개월 후에는 어떤 파일이 어떤 기능을 담당하는지 기억하지 못할 것입니다. 의사결정 로그와 아키텍처 맵은 이러한 질문에 대한 답을 여러분과 AI 모두에게 제공합니다.

AI는 여러분이 개발하는 동안 이 모든 것을 자동으로 관리합니다. 여러분은 문서를 업데이트할 필요가 없습니다. AI가 알아서 처리합니다.

## 설계 원칙

이러한 파일의 구조와 작동 원리를 설명하는 다섯 가지 아이디어.

**일괄 로딩이 아닌 계층형 컨텍스트** AI는 먼저 `CLAUDE.md` 파일(약 800개 토큰)을 읽어 프로젝트를 이해하고 필요한 정보를 찾습니다. 그런 다음 작업에 필요한 경우에만 더 자세한 문서(`APP_ARCHITECTURE.md`, `DECISION_LOG.md`, `PRD.md`)를 로드합니다. 어떤 세션에서도 모든 문서를 로드하지 않습니다. 이는 불필요한 컨텍스트가 적을수록 모델 성능이 향상된다는 [ICM](https://github.com/RinDig/Interpreted-Context-Methdology) 원칙을 반영한 것으로, 압축보다는 예방에 중점을 둡니다.

**일반 텍스트를 보편적인 인터페이스로 사용합니다.** 모든 컨텍스트 파일은 마크다운 형식입니다. 데이터베이스도, 독점 형식도, 도구별 설정도 필요 없습니다. 텍스트 파일을 읽을 수 있는 모든 AI 도구(Claude Code, Cursor, Copilot, 복사 붙여넣기 기능이 있는 ChatGPT 등)가 모든 이점을 누릴 수 있습니다. 텍스트 편집기를 열 수 있는 사람이라면 누구나 파일을 검토하거나 수정할 수 있습니다.

**단일 진실의 출처.** 모든 정보는 정확히 한 곳에만 존재합니다. 아키텍처는 `APP_ARCHITECTURE.md`에, 결정 사항은 `DECISION_LOG.md`에, 기능 및 우선순위는 `PRD.md`에 저장됩니다. 다른 파일들은 이러한 파일들을 참조하지만, 절대 중복해서 저장하지 않습니다. 동일한 정보가 두 파일에 존재하는 순간, 두 파일은 서로 분리되어 AI가 충돌하는 신호를 받게 됩니다.

**인공지능은 자체적인 맥락을 유지합니다.** 사람이 직접 관리해야 하는 문서는 관리되지 않습니다. `CLAUDE.md` 규칙은 AI가 파일을 생성할 때 아키텍처 맵을 업데이트하고, 절충안을 선택할 때 결정을 기록하며, 기능을 출시할 때 PRD에 완료 표시를 하도록 지시합니다. 시스템이 최신 상태를 유지하는 것은 AI 워크플로의 일부이며, 별도의 작업이 아닙니다.

**제품이 아닌 공장을 구성합니다.** 컨텍스트 시스템(프로젝트 구조, 규칙, 결정 사항 및 우선순위)은 한 번만 설정하면 됩니다. 그 후에는 모든 세션에서 동일한 구성을 사용하여 작업을 생성합니다. 이는 ICM의 작업 공간 설계 원칙과 동일합니다. 즉, 프로덕션 시스템을 정의한 다음 재구성 없이 반복적으로 실행할 수 있도록 하는 것입니다.

## 토큰 효율성

다양한 규모의 실제 프로젝트를 기준으로 측정했습니다.

| 프로젝트 크기 | Cortex 미사용 | Cortex 사용 | 축소 비율 |
|---|---|---|---|
| 소형 (파일 20개) | 탐색 토큰 약 15,000개 | Cortex 사용 시 토큰 약 1,500개 | **10배** |
| 중형 (파일 50개) | 탐색 토큰 약 35,000개 | Cortex 사용 시 토큰 약 2,000개 | **17배** |
| 대형 (파일 100개 이상) | 탐색 토큰 약 60,000개 | Cortex 사용 시 토큰 약 3,000개 | **20배** |

### 이것이 기술적으로 중요한 이유

**더 나은 답변.** LLM(대형 언어 모델)은 컨텍스트 창이 가득 찰수록 성능이 저하됩니다. 연구 결과는 모델이 관련 없는 컨텍스트 데이터가 많을 때(소위 "중간에서 길을 잃다" 문제) 정확도가 떨어진다는 것을 일관되게 보여줍니다. 40,000개의 토큰으로 구성된 원시 파일 탐색 데이터 대신 2,000개의 선별된 컨텍스트 데이터를 AI에 제공함으로써, 모든 응답은 더 깨끗하고 관련성 높은 신호를 기반으로 작동합니다.

**세션당 도구 호출 횟수가 줄어듭니다.** 컨텍스트 파일이 없으면 AI는 세션당 처음 5 ~ 15번의 도구 호출에서 단순히 `read_file`과 `list_directory`를 실행하여 프로젝트를 파악합니다. 하지만 이 템플릿을 사용하면 AI는 바로 필요한 작업으로 넘어갑니다. 중간 규모 프로젝트의 경우, 세션당 탐색 호출 횟수가 약 60 ~ 80% 감소합니다.

**더 빠른 응답.** 컨텍스트 크기가 작을수록 추론 속도가 빨라집니다. 컨텍스트 창의 각 토큰은 지연 시간을 증가시킵니다. 탐색 과정에서 발생하는 노이즈 토큰 3만 개 이상을 제거하면 AI가 응답을 생성하는 속도가 눈에 띄게 빨라지며, 특히 Opus와 같은 대형 모델에서 이러한 효과가 두드러집니다.

**실수와 수정 작업이 줄어듭니다.** AI가 자체적으로 탐색할 때, 잘못된 파일을 읽거나, 아키텍처에 대해 잘못된 가정을 하거나, 적합하지 않은 코드를 생성하는 경우가 있습니다. 그러면 AI는 되돌아가서 다시 시도해야 하므로 토큰과 시간이 더 많이 소모됩니다. 사전 로드된 컨텍스트는 이러한 잘못된 시작을 대부분 방지해 줍니다.

**사용 한도의 더 많은 부분이 실제 업무에 사용됩니다.** 구독 플랜(Cursor Pro, Claude Code Max)에서는 요청 횟수가 정해져 있습니다. AI가 프로젝트를 재탐색하는 데 낭비하는 모든 요청은 기능 개발, 버그 수정 또는 질문 답변에 사용될 수 없는 기회입니다.

설정 후 프로젝트에서 `bash benchmark.sh`를 실행하여 실제 토큰 수를 확인하세요.

## 내용물

```
your-project/
├── CLAUDE.md                  AI가 먼저 이 내용을 읽습니다. 프로젝트 개요, 작업 라우팅, 규칙 등이 포함됩니다.
├── SETUP.md                   붙여넣을 프롬프트 하나만 있으면 됩니다. AI가 사용자의 위치를 ​​묻고 모든 설정을 완료합니다.
├── docs/
│   ├── PRD.md                 제품 사양: 기능, 우선순위, 완료된 사항, 향후 계획.
│   ├── APP_ARCHITECTURE.md    파일 맵: 모든 파일, 각 파일의 기능, 파일 간 연결 방식.
│   ├── DECISION_LOG.md        의사 결정 이력: 상황이 현재와 같은 이유.
│   └── INDEX.md               모든 문서에 대한 빠른 참조.
├── .cursor/rules/             (커서 사용자) 사용자가 편집 중인 파일에 따라 자동으로 로드되는 컨텍스트입니다.
│   ├── project.mdc            항상 로드됨: 라우팅 + 규칙.
│   └── feature-example.mdc    범위 지정 규칙 템플릿(AI가 설정 중에 더 많은 템플릿을 생성합니다).
├── .cursorignore              생성된 대용량 파일이 AI 검색 결과에 포함되지 않도록 합니다.
├── .gitignore                 실수로 기밀 정보를 유출하지 않도록 보안 패턴이 포함되어 있습니다.
├── .github/workflows/         (선택 사항) 자동화된 일일 요약, 테스트 실행, 주간 보고서.
└── benchmark.sh               이 코드를 실행하여 토큰 절약액을 확인하세요.
```

## Works With

이 파일들은 일반 마크다운 파일입니다. 텍스트 파일을 읽을 수 있는 모든 AI 도구가 이를 활용할 수 있습니다.

| Tool | 작동 방식 |
|------|-------------|
| **Claude Code** (desktop app) | 세션 시작 시 `CLAUDE.md` 파일을 자동으로 읽어줍니다. 최상의 사용자 경험을 제공합니다. |
| **Cursor** | `CLAUDE.md` 파일을 읽고 열려 있는 파일에 따라 범위가 지정된 `.mdc` 규칙을 자동으로 로드합니다. 최상의 사용자 경험을 제공합니다. |
| **Windsurf, Copilot, Cline, Aider, Codex** | `CLAUDE.md` 파일이나 문서 폴더를 참조하도록 안내하세요. 그러면 맥락을 이해하고 더 잘 작업할 것입니다. |
| **Claude.ai, ChatGPT** (web/mobile) | 프로젝트 관련 정보를 즉시 확인하려면 `CLAUDE.md` 파일을 대화창에 복사하여 붙여넣으세요.|

## 빠른 시작

### 1. github 에서 파일 가져오기

**새 프로젝트 시작하기:**

```bash
mkdir my-app && cd my-app
git clone https://github.com/wsk2001/cortex.git _cortex-setup && cp -r _cortex-setup/CLAUDE.md _cortex-setup/SETUP.md _cortex-setup/benchmark.sh _cortex-setup/docs _cortex-setup/.cursorignore _cortex-setup/.cursor _cortex-setup/.gitignore _cortex-setup/.github . 2>/dev/null; rm -rf _cortex-setup
```

**기존 프로젝트에 추가하기:**

```bash
cd your-project
```
`Linux 용`
```bash
git clone https://github.com/wsk2001/cortex.git _cortex-setup && cp -r _cortex-setup/CLAUDE.md _cortex-setup/SETUP.md _cortex-setup/benchmark.sh _cortex-setup/docs _cortex-setup/.cursorignore _cortex-setup/.cursor _cortex-setup/.gitignore _cortex-setup/.github . 2>/dev/null; rm -rf _cortex-setup
```

`Windows CMD 용`
```cmd
git clone https://github.com/wsk2001/cortex.git _cortex-setup

xcopy _cortex-setup\CLAUDE.md . /Y
xcopy _cortex-setup\SETUP.md . /Y
xcopy _cortex-setup\benchmark.sh . /Y
xcopy _cortex-setup\docs docs\ /E /I /Y
xcopy _cortex-setup\.cursorignore . /Y
xcopy _cortex-setup\.cursor .cursor\ /E /I /Y
xcopy _cortex-setup\.gitignore docs\ /Y
xcopy _cortex-setup\.github .github\ /E /I /Y

rmdir /S /Q _cortex-setup
```

`Windows PowerShell 용`
```powershell
git clone https://github.com/wsk2001/cortex.git _cortex-setup
Copy-Item _cortex-setup\CLAUDE.md, _cortex-setup\SETUP.md, _cortex-setup\benchmark.sh, _cortex-setup\docs, _cortex-setup\.cursorignore, _cortex-setup\.cursor, _cortex-setup\.gitignore, _cortex-setup\.github -Destination .
Remove-Item -Recurse -Force _cortex-setup
```


### 2. 클로드 코드 또는 커서를 열고 `setup` 을 입력하세요 
```bash
# 역자는 opencode 에서 테스트 하고 있음
setup
```

이게 전부입니다. AI는 `CLAUDE.md` 파일을 읽고, 설정 트리거를 확인한 다음, `SETUP.md` 파일의 온보딩 지침을 읽고, 진행 상황을 묻습니다. 사용자의 답변에 따라 적절한 온보딩 프로세스를 실행합니다.

- **Just an idea?** 이 시스템은 당신과 인터뷰를 하고, 제품 사양을 작성한 다음, 모든 설정을 완료합니다.
- **Some code already?** 이 프로그램은 프로젝트를 스캔하고, 문서를 작성하며, 개선 사항을 제안합니다.
- **Live app?** 이는 존재하는 것을 기록하고, 부족한 것만 추가합니다.
- **Inherited project?** 이 프로그램은 코드베이스를 설명해 줄 뿐만 아니라 시스템 설정도 도와줍니다.

### 3. Build

앞으로 진행될 모든 세션은 전체적인 맥락을 파악한 상태에서 시작됩니다. "다음에는 무엇을 작업해야 할까요?"라고 물으면 AI가 제품 사양을 읽고 가장 우선순위가 높은 기능을 제안합니다.

하루 일과가 끝나면 <span style="color: blue">"마무리"</span> ("wrap up") 라고 말하세요. 그러면 AI가 모든 문서를 자동으로 업데이트합니다.

## 이 방법이 효과가 없는 경우

Cortex는 AI를 활용한 앱을 개발하는 한 사람(또는 소규모 팀)을 위해 설계되었습니다. 따라서 한계가 있습니다.

**Multi-agent orchestration.** 여러 AI 에이전트가 실시간으로 협업하여 메시지를 주고받고, 동적으로 분기하고, 동시 파이프라인을 실행해야 하는 경우, CrewAI, LangGraph, AutoGen과 같은 실제 프레임워크가 필요합니다. 이는 런타임 조정이 아닌 정적 컨텍스트 파일을 사용하는 방식입니다.

**Team-scale projects with many contributors.** 컨텍스트 파일은 한 사람이 결정을 내리고 하나의 AI가 이를 읽는다는 가정하에 작성되었습니다. 10명의 엔지니어가 각기 다른 브랜치에서 작업하는 경우, 아키텍처 맵과 의사 결정 로그는 끊임없이 충돌할 것입니다. 대신 적절한 엔지니어링 문서와 코드 검토 워크플로를 활용하세요.

**Non-code workflows.** 이 도구는 앱 개발용으로 설계되었습니다. 콘텐츠 제작, 데이터 파이프라인 또는 다단계 문서 처리와 같은 워크플로우를 사용하는 경우, 단계별 파이프라인 구조를 제공하는 [ICM](https://github.com/RinDig/Interpreted-Context-Methdology)과 같은 도구가 더 적합합니다.

**Projects that change AI tools frequently.** `.cursor/rules/` 파일은 Cursor에서만 작동합니다. 여러 도구를 자주 전환하는 경우 `CLAUDE.md`와 docs 폴더는 유용하지만 Cursor 전용 파일은 이전되지 않습니다.

**Massive monorepos.** 프로젝트에 여러 서비스에 걸쳐 1,000개 이상의 파일이 있는 경우, 단일 `APP_ARCHITECTURE.md`로는 확장이 불가능합니다. 서비스별 컨텍스트 파일과 더욱 정교한 라우팅 시스템이 필요합니다.
## ~에서 영감을 받음

- [Andrej Karpathy's context engineering](https://x.com/karpathy) -- "다음 단계에 필요한 정확한 정보로 컨텍스트 창을 채웁니다."

## License

MIT. Use it, modify it, share it.
