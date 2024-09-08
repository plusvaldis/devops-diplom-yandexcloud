# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя  
Создан сервисный аккаунт в CLI yc. 
```bash
yc iam service-account create --name cherepanov
yc resource-manager folder  add-access-binding --id b1gqnsno2p3pm085m9d6 --role editor --service-account-id ajenit04k8nlosvd750h
yc iam service-account add-access-binding cherepanov --role editor --subject userAccount:ajenit04k8nlosvd750h
yc iam key create --service-account-id ajenit04k8nlosvd750h --output key.json
```  

2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
В данном пункте, я предпочел выбрать вариант а, создав отдельную конфигурацию, для автоматического деплоя бэкенда.
[backend.tf](https://github.com/plusvaldis/devops-diplom-yandexcloud/tree/main/diplom_bucket "backend")  

3. Создайте VPC с подсетями в разных зонах доступности.  
![network](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/one-point/network1.png)  
![network](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/one-point/network2.png)  

4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.  

5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.  
![network](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/one-point/backend.png)  

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.  
Во втором блоке, я решил самостоятельно установить kubernetes кластер, применив практику с лекций. Развертывание кластера, происходит в момент создания инфраструктуры, после того как вся инфраструктура настроена и доступна, выполняется вызов ansible скрипта, воспользовался kubespray установкой. 
[Kubernetes-install.yml](https://github.com/plusvaldis/devops-diplom-yandexcloud/tree/main/terraform/ansible/kubernetes_install.yml "backend")  

2. В файле `~/.kube/config` находятся данные для доступа к кластеру.  
![kubeconfig](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/two-point/kubeconfig.png)  

3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.  
![kubeget](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/two-point/kubeget.png)  

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.  
[GitHub repo my app](https://github.com/plusvaldis/simple-nginx-dev "my-app")  

2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.  
Сборка приложения и пуш в репозиторий происходит во время создания инфраструктуры.  
[Ansible скрипт настройки ВМ и пуш собранного приложения в гит](https://github.com/plusvaldis/devops-diplom-yandexcloud/tree/main/terraform/ansible/docker_install.yml "my-app")  
![regystry](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/free-point/registry.png)  

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

2. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.  
При выполнении данного блока, воспользовался пакетом который указан в способах полнения kube-prometheus, который разворачивается во время настройки инфраструктуры. С помощью ansible скрипта. [Ansible скрипт deploy monitoring](https://github.com/plusvaldis/devops-diplom-yandexcloud/tree/main/terraform/ansible/monitoring_install.yml "monitoring")  

2. Http доступ к web интерфейсу grafana.  
[Grafana](http://89.169.137.163:32000/ "web app")  

3. Дашборды в grafana отображающие состояние Kubernetes кластера.  
![monitoring](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/four-point/grafana.png)  

4. Http доступ к тестовому приложению.  
![monitoring](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/four-point/myapp-nginx.png)  

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.  

Для выполнения следующих пунктов, потребовалось создать:
[Jenkinsfile](https://github.com/plusvaldis/simple-nginx-dev/blob/main/Jenkinsfile "Jenkinsfile")  
Добавить необходимые Credentials:
![cred](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/cred.png)  
Добавить в настройки Jenkins сервер GitHub  
![githubauth](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/githubauth.png)  


2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.  
При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.  

Автоматический запуск pipeline выполняется с помощью настройки webhooks в репозитории приложения. По определению наличия изменений в ветке main, со стороны jenkins, создан Мультиконфигурационный проект, где указан наш github репозиторий, так же настроены правила для обнаружения в tag изменений.  
![multiconfig](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/multiconfig1.png)   
![multiconfig](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/multiconfig2.png)
Создал понимание инфраструктуры такое как: если выполняется push в ветке main, то считаем что это тестовое приложение, выполняем сборку и отправку в regystry с соотвествующим label (branch_name+git_commit), а также последующий деплой в staging пространстве.  
![autodeploypush](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/pushmain.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeployprod1.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeployprod2.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeployprod3.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeployprod4.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeployprod5.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeployprod6.png)  

3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.  
Если же, происходит сборка например тега v.*, считаем что это релизное приложение для prod. выполняем также сборку приложения и отправляем в registry с соответствующим label (tag_name), после происходит сборка в пространстве prod.  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest1.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest2.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest3.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest4.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest5.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest6.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest7.png)  
![autodeploy](https://github.com/plusvaldis/devops-diplom-yandexcloud/blob/main/images/autodeploytest8.png)  




---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.  
[Terraform on Github](https://github.com/plusvaldis/devops-diplom-yandexcloud/tree/main/terraform "github")  

2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.  

3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.  
[Ansible on Github for kubespray](https://github.com/plusvaldis/kube-prometheus "github")  

4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.  
[My-app on GitHub](https://github.com/plusvaldis/simple-nginx-dev "github")  

5. Репозиторий с конфигурацией Kubernetes кластера.  


6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.  
[Website myapp создание из блока Подготовка cистемы мониторинга и деплой приложения](http://89.169.153.114 "web app")  
[Website myapp-testing-namespace создание из блока Подготовка cистемы мониторинга и деплой приложения](http://89.169.137.163:32081/ "web app")  
[Website myapp-production-namespace создание из блока Подготовка cистемы мониторинга и деплой приложения](http://89.169.137.163:32080/ "web app")  
[Grafana](http://89.169.137.163:32000/ "web app")  
Login: teacher Pass: teacher123


7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)  


