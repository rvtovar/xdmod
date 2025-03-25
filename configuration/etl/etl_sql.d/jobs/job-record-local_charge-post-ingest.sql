UPDATE
    ${DESTINATION_SCHEMA}.job_tasks tasks
    JOIN
    ${DESTINATION_SCHEMA}.resourcefact rf ON tasks.resource_id = rf.id
    JOIN
    ${DESTINATION_SCHEMA}.resource_allocation_type rat ON rf.resource_allocation_type_id = rat.resource_allocation_type_id
    SET
        tasks.local_charge_su =
        CASE
        WHEN rat.resource_allocation_type_abbrev = 'CPU' THEN 1.0 * tasks.processor_count * (tasks.wallduration / 3600.0)
        WHEN rat.resource_allocation_type_abbrev = 'GPU' THEN 1.0 * tasks.gpu_count * (tasks.wallduration / 3600.0)
        WHEN rat.resource_allocation_type_abbrev = 'CPUNode' THEN 1.0 * tasks.node_count * (tasks.wallduration / 3600.0)
        WHEN rat.resource_allocation_type_abbrev = 'GPUNode' THEN 1.0 * tasks.gpu_count * (tasks.wallduration / 3600.0)
END;

