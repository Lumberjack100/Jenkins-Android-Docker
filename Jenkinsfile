pipeline {
    agent any

    parameters {
        string(name: 'branch', defaultValue: 'fea_v3.0', description: 'Git branch to build')
    }

    triggers {
        // 配置触发器，具体配置依据实际插件和需求
        GenericTrigger(
            genericVariables: [
                [key: 'ref', value: '$.ref']
            ],
            causeString: 'Triggered on $ref',
            token: 'mcloudapp-iot-beta',
            printContributedVariables: true,
            printPostContent: true,
            silentResponse: false,
            regexpFilterText: '',
            regexpFilterExpression: '.*'
        )
    }

    options {
        // 配置旧构建丢弃策略
        buildDiscarder(logRotator(daysToKeepStr: '7', numToKeepStr: '7'))
    }

    stages {
        stage('Preparation') {
            steps {
                // 删除上次构建的目录
                deleteDir()
                // 检出代码
                git branch: "${params.branch}", credentialsId: '2201ce1a-d141-4b4c-bde4-5d77d285246d', url: 'https://gitlab.shmedo.cn/mcloud-app/mCloudapp.git'
            }
        }

        stage('Build') {
            steps {
                // 使用Gradle Wrapper构建
                sh './gradlew clean assembleProductionRelease -debug -stacktrace'
            }
        }

    // stage('Notifications') {
    //     // 根据构建结果发送通知
    //     post {
    //         success {
    //             // 构建成功时的操作
    //            wrap([$class: 'BuildUser']) {
    //         dingtalk(
    //             robot: 'Jenkins-Dingtalk',
    //             type: 'MARKDOWN',
    //             title: "success: ${JOB}",
    //             text: ["### 项目信息",
    //                 '---',
    //                 "- 项目: 米易通",
    //                 '---',
    //                 "### 构建信息",
    //                 '---',
    //                 "- 构建编号: <font color=#008000>${BUILD_ID}</font>",
    //                 "- 构建列表: ${JOB}",
    //                 "- 构建分支: ${BRANCH_TAG}",
    //                 "- 构建环境: ${ENV}",
    //                 "- 构建状态: **<font color=#008000>${currentBuild.result}</font>**",
    //                 "- 项目地址: ${BUILD_URL}",
    //                 "- 构建日志: ${BUILD_URL}console",
    //                 "",
    //                 '---',
    //                 "### 是否启动",
    //                 '---',
    //                 "- 构建后启动: ${START}",
    //                 "",
    //                 '---',
    //                 "### 执行人",
    //                 '---',
    //                 "- ${env.BUILD_USER}",
    //                 "",
    //                 '---',
    //                 "### 持续时间",
    //                 '---',
    //                 "- ${currentBuild.durationString}",
    //                 "",
    //                 '---']
    //         )
    //     }
    //         }
    //     }
    // }
    }

    post {
        always {
            // 构建后总是执行的操作，例如归档APK文件
            archiveArtifacts artifacts: '**/*.apk', fingerprint: true
        }
    }
}
