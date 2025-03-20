UPDATE
    ${DESTINATION_SCHEMA}.job_records records
    JOIN
    ${DESTINATION_SCHEMA}.resourcefact rf ON records.resource_id = rf.id
    JOIN
    ${DESTINATION_SCHEMA}.resource_allocation_type rat ON rf.resource_allocation_type_id = rat.resource_allocation_type_id
    JOIN
    ${DESTINATION_SCHEMA}.job_tasks tasks on records.job_record_id = tasks.job_record_id
    SET
        records.local_charge_su =
        CASE
        WHEN rat.resource_allocation_type_abbrev = 'CPU' THEN 1 * tasks.processor_count * (tasks.wallduration / 3600)
        WHEN rat.resource_allocation_type_abbrev = 'GPU' THEN 1 * tasks.gpu_count * (tasks.wallduration / 3600)
        WHEN rat.resource_allocation_type_abbrev = 'CPUNode' THEN 1 * tasks.node_count * (tasks.wallduration / 3600)
        WHEN rat.resource_allocation_type_abbrev = 'GPUNode' THEN 1 * tasks.gpu_count * (tasks.wallduration / 3600)
END;

