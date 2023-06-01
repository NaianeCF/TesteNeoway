--11.853
select distinct cnpj from df_empresas1
--except
--11.853
select distinct cnpj from empresas_porte1

--424
select	ep.*,
		em.*
	from df_empresas1 em
		inner join empresas_porte1 ep
			on em.cnpj = ep.cnpj

--11.853
select distinct cnpj from empresas_nivel_atividade1

--422
select	na.*,
		em.*
	from df_empresas1 em
		inner join empresas_nivel_atividade1 na
			on em.cnpj = na.cnpj

--11.868
select distinct cnpj from empresas_simples1

--407
select 	es.*,
		em.*
	from df_empresas1 em
		inner join empresas_simples1 es
			on em.cnpj = es.cnpj

--11.853
select distinct cnpj from empresas_saude_tributaria1

--417
select 	st.*,
		em.*
	from df_empresas1 em
		inner join empresas_saude_tributaria1 st
			on em.cnpj = st.cnpj

--11.853
select distinct vl_cnpj from empresas_bolsa1

--256
select 	eb.*,
		em.*
	from df_empresas1 em
		inner join empresas_bolsa1 eb
			on em.cnpj = eb.vl_cnpj


select cb.index_level_0,
		*
	from empresas_bolsa1 eb
		inner join cotacoes_bolsa cb
			on eb.id = cb.id
			--on eb.id = cb.index_level_0
	where cb.index_level_0 = 1
	order by eb.id, cb.index_level_0

select  count(*) as qtd,
		eb.vl_cnpj
	from empresas_bolsa1 eb
	group by eb.vl_cnpj
	having count(*) > 1


--Faixa de idade das empresa
select	COUNT(em.cnpj) as qtd,
		DATEDIFF(YEAR, em.dt_abertura,GETDATE()) as Anos_Empresa
from df_empresas1 em 
group by DATEDIFF(YEAR, em.dt_abertura,GETDATE())
order by qtd desc




