GIT = [
    SCRIPT_REPO: 'https://github.com/insorion/maven_java_web_example.git',
    SCRIPT_FILE: 'code',
    BRANCH: 'master'
]

SOURCECODE = [
    POM: './pom.xml',
]

DOCKER = [
    // BUILD_IMAGE: true,
    REGISTRY_CREDS: '6fca0758-9e15-457e-a7e2-e9fd1dce9784',
    REGISTRY_PULL_URL: 'hub.docker.com',
    REGISTRY_PUSH_URL: 'hub.docker.com'
]



node('master') {
    stage('Checkout') {
        // git credentialsId: 'aws-snaps-2', url: GIT.SCRIPT_REPO, branch: GIT.BRANCH
        git GIT.SCRIPT_REPO
    }
    
    stage('build') {
        sh 'echo "THIS IS A BUILD STEP"'
        sh 'echo gugush'
        sh 'mvn clean package -DskipTests'
    }

    stage('Test') {
            sh 'echo "TESTING STAGE"'
            sh 'mvn test'
            }

    
    stage('Docker image build and push'){
        stage('Set version for docker') {
            docker_image_version = common.get_version_from_pom(SOURCECODE.POM)
            docker_component_name = common.get_artifact_name_from_pom(SOURCECODE.POM)

            println('Changing component name and version in Dockerfile')
            common.set_component_data_dockerfile(docker_component_name, docker_image_version, './Dockerfile')

            sh 'cat ./Dockerfile'
        }
        withCredentials([
                    usernamePassword(
                        credentialsId: DOCKER.REGISTRY_CREDS,
                        passwordVariable: 'DOCKER_PASSWORD',
                        usernameVariable: 'DOCKER_USER')
        ]) {
            
        //    docker_image = "${DOCKER.REGISTRY_PUSH_URL}/repository/docker/insorion/java-sample:${docker_image_version}"
           docker_image = "insorion/java-sample:${docker_image_version}"
           sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}"
        //    def war_version = common.get_version_from_pom(SOURCECODE.POM, false, false)
           def artifact_full_path = "${SOURCECODE.PATH_TO_war}${SOURCECODE.ARTIFACT_NAME}-${war_version}.war"
           
           sh """docker build -t ${docker_image} \
              --build-arg war_FILE=${artifact_full_path} ."""
           sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} ${DOCKER.REGISTRY_PUSH_URL}"
           sh "docker push ${docker_image}"           
            
        }                
    }
}
