allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // Avoid force-evaluating the :app project during root configuration because that triggers
    // Android plugin configuration (which may check NDK) and can cause the reported error.
    // If you need to act after all projects are configured, use gradle.projectsEvaluated { ... }
}
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
