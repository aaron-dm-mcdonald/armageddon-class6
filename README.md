# BOS Sacrafice

## Overview

Armageddon project for class 6. 

## Modules
- backend
- frontend
- network
- tgw_branch
- tgw_hq
- log (placeholder)


## Project Structure

- ./
    - 0-var.tf
    - 1-auth.tf
    - 2-main.tf
    - a-tokyo.tf
    - b-osaka.tf
    - c-new_york.tf
    - d-london.tf
    - e-sao_paulo.tf
    - f-sydney.tf
    - g-
    - h-
    - terraform.tfplan
    - modules/
        - backend/
            - main.tf
            - outputs.tf
            - variables.tf
        - frontend/
            - main.tf
            - outputs.tf
            - variables.tf
        - log/
            - main.tf
            - output.tf
            - variables.tf
        - network/
            - gateway.tf
            - main.tf
            - output.tf
            - rtb.tf
            - subnets.tf
            - variables.tf
        - tgw_branch/
            - main.tf
            - output.tf
            - provider.tf
            - variable.tf
        - tgw_hq/
            - main.tf
            - output.tf
            - variables.tf
    - scripts/
        - startup.sh
