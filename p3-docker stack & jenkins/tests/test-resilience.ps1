# test-resilience.ps1

param(
    [string]$Worker = "worker1"
)

$Manager = "manager"

Write-Host "[INFO] Restarting $Worker..."
vagrant reload $Worker

Write-Host "[INFO] Waiting for $Worker to be ready..."
vagrant ssh $Worker -c "echo 'Worker is up'"

Write-Host "[INFO] Checking Docker Swarm service status on $Manager..."
vagrant ssh $Manager -c "docker node ls && docker service ls && docker service ps $(docker service ls --format '{{.Name}}')"

Write-Host "[INFO] Resilience test completed. Review the output above for service health."
