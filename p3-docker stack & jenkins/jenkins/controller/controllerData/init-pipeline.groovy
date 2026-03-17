import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition

def jenkins = Jenkins.get()

// Mapa: "Nazwa Joba" : "Ścieżka do Jenkinsfile"
def jobsMap = [
    "build-agent" : "/piplines/build-on-agent/Jenkinsfile",
    "build-ssh"   : "/piplines/build-on-ssh/Jenkinsfile"
]

// Iteracja po każdym elemencie mapy
jobsMap.each { jobName, jobPath ->
    
    println("\n--- Przetwarzanie: ${jobName} ---")

    // 1. Sprawdzenie i usunięcie starego joba
    def existing = jenkins.getItemByFullName(jobName)
    if (existing != null) {
        println("Job '${jobName}' już istnieje -> usuwam i tworzę na nowo.")
        existing.delete()
    }

    // 2. Weryfikacja czy plik Jenkinsfile istnieje
    def file = new File(jobPath)
    if (!file.exists()) {
        println("BŁĄD: Nie znaleziono Jenkinsfile dla '${jobName}' pod ścieżką: ${jobPath}. Pomijam tworzenie.")
        return // Przejdź do następnego elementu pętli
    }

    // 3. Tworzenie nowego projektu
    println("Tworzę job: ${jobName}")
    def workflowJob = jenkins.createProject(WorkflowJob.class, jobName)

    // 4. Wczytanie treści i ustawienie definicji
    try {
        def jenkinsfileContent = file.text
        // true w konstruktorze oznacza 'sandbox' (zazwyczaj wymagane)
        def flowDefinition = new CpsFlowDefinition(jenkinsfileContent, true)
        
        workflowJob.setDefinition(flowDefinition)
        workflowJob.save()
        
        println("SUKCES: Job '${jobName}' został utworzony ze ścieżki ${jobPath}.")
    } catch (Exception e) {
        println("BŁĄD podczas tworzenia definicji dla '${jobName}': ${e.message}")
    }
}

// Zapisanie stanu Jenkinsa na koniec (opcjonalne, ale dobra praktyka po zmianach konfiguracji)
jenkins.save()
println("\nZakończono inicjalizację jobów.")