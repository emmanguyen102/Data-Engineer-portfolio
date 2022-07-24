use [DEP302x_ASM1]
go

-- 1.How many dogs get vaccinated?
select count(*) as dog_vaccinated_count from Pet_FACT p 
join Type_DIM t on t.typeID = p.dim_type_id
join Med_DIM m on m.healthID = p.dim_med_id
where t.type = 'Dog' and m.Vaccinated = 'Yes'
go

-- 2.How many dogs that are healthy?
select count(*) as dog_healthy_count from Pet_FACT p 
join Type_DIM t on t.typeID = p.dim_type_id
join Med_DIM m on m.healthID = p.dim_med_id
where t.type = 'Dog' and m.Health = 'Healthy'
go


-- 3.How many dogs are female in state Pahang ?
select count(*) as dog_female_Pahang_count from Pet_FACT p 
join Type_DIM t on t.typeID = p.dim_type_id
join Gender_DIM g on g.genderID = p.dim_gender_id
join State_DIM s on s.stateID = p.dim_state_id
where t.type = 'Dog' and g.genderID = 6 and s.stateID = 35
go

