# Conversational Analytics Hands-on 환경 설정 가이드 (aeon-workshop-demo)

이 가이드는 **`aeon-workshop-demo`** 프로젝트에 Terraform을 사용하여 BigQuery 실습용 데이터셋 환경을 배포하는 단계를 안내합니다.

---

## 1. 사전 요구 사항

배포를 진행하기 전, 로컬 개발 환경에 아래 도구들이 설치 및 설정되어 있어야 합니다:

* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (>= 1.0)
* [Google Cloud SDK (gcloud CLI)](https://cloud.google.com/sdk/docs/install)
* `aeon-workshop-demo` 프로젝트에 대한 **Owner** 또는 **Editor** 권한이 있는 Google 계정

---

## 2. 배포 및 적용 순서

### 2.1 GCP 인증 설정
로컬 환경에서 Google Cloud 리소스에 접근할 수 있도록 애플리케이션 기본 자격 증명(ADC)을 설정합니다:

```bash
gcloud auth application-default login
```
*브라우저가 열리면 `aeon-workshop-demo` 프로젝트 권한이 부여된 Google 계정으로 로그인해 주세요.*

### 2.2 Terraform 초기화
프로바이더 플러그인(Google Cloud Provider)을 다운로드하기 위해 디렉토리를 초기화합니다:

```bash
terraform init
```

### 2.3 환경 변수 파일 생성 (`terraform.tfvars`)
매번 명령어 실행 시 프로젝트 ID를 입력하는 번거로움을 줄이기 위해, `terraform.tfvars` 파일을 생성하여 기본 프로젝트 설정을 정의합니다.

터미널에서 아래 명령어를 실행하여 파일을 자동 생성할 수 있습니다:

```bash
cat <<EOF > terraform.tfvars
project_id = "aeon-workshop-demo"
region     = "US"
EOF
```

### 2.4 Terraform 실행 계획 확인
실제 GCP 상에 어떤 리소스들이 생성되는지 확인합니다:

```bash
terraform plan
```

### 2.5 리소스 배포 적용
최종적으로 리소스를 GCP에 생성합니다:

```bash
terraform apply -auto-approve
```

배포가 성공적으로 완료되면 아래와 같이 출력 정보(Outputs)가 터미널에 표시됩니다.
* **`dataset_id`**: 생성된 빅쿼리 데이터셋 이름 (`google_analytics_sample`)
* **`view_id`**: 생성된 빅쿼리 뷰 테이블 주소
* **`query_example`**: 빅쿼리 워크스페이스에서 즉시 테스트 가능한 쿼리 샘플

---

## 3. 실습 진행

정상적으로 배포가 완료되었다면, **[handson.md](file:///Users/minsoojun/work/Aeon/Conversational%20Analytics%20Handson/handson.md)** 파일을 열고 BigQuery 실습 단계 및 샘플 SQL 쿼리를 참고하여 분석을 진행하시기 바랍니다.

---

## 4. 리소스 정리 (삭제)

실습이 끝난 후, 생성된 모든 클라우드 자원을 제거하여 추가 요금 청구를 방지합니다:

```bash
terraform destroy -auto-approve
```
