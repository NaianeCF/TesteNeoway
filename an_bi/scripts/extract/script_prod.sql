
/* 
Consulta CNPJ: http://receitaws.com.br/v1/cnpj/39392850000118 
*/

/*

DROP TABLE [dbo].[BI_EMP_FEmpresas]
CREATE TABLE [dbo].[BI_EMP_FEmpresas](
	[CNPJ] [nvarchar](50) NOT NULL,
	[CNPJ Formatado] [nvarchar](50) NULL,
	[Data Abertura] [date] NOT NULL,
	[Nome Empresa] [nvarchar](50) NULL,
	[Situação] [nvarchar](50) NOT NULL,
	[Saúde Tributária] [nvarchar](50) NULL,
	[Porte] [nvarchar](50) NULL,
	[Matriz/Filial] [varchar](6) NOT NULL,
	[Simples] [varchar](3) NULL,
	[SIMEI] [varchar](3) NULL,
	[UF] [char](10) NOT NULL,
	[Mesorregião] [nvarchar](50) NOT NULL,
	[Região] [nvarchar](50) NOT NULL,
	[Cidade] [nvarchar](50) NOT NULL,
	[CEP] [int] NOT NULL,
	[Ramo Atividade] [nvarchar](50) NULL,
	[Nível Atividade] [nvarchar](50) NULL,
	[Setor] [nvarchar](50) NULL,
	[Cód. CNAE] [int] NULL,
	[Desc. CNAE] [nvarchar](250) NOT NULL,
	[Faixa Tempo Empresa] [varchar](14) NULL,
	[Ordem Faixa] [int] NULL,
	[Acao RDZ] [nvarchar](50) NULL,
	[Setor bolsa] [nvarchar](50) NULL,
	[Subsetor] [nvarchar](100) NULL,
	[Segmento] [nvarchar](100) NULL,
	[Cód. Segmento B3] [nvarchar](50) NULL,
	[Segmento B3] [nvarchar](50) NULL,
	[Cód. Acao] [nvarchar](50) NULL
)

DROP TABLE [dbo].[BI_EMP_Cotacoes]
CREATE TABLE [dbo].[BI_EMP_Cotacoes1](
	[ID] [int] NULL,
	[Data Pregão] [date] NULL,
	[Ativo] [nvarchar](50) NULL,
	[Empresa] [nvarchar](100) NULL,
	[Moeda] [nvarchar](50) NULL,
	[Valor Abertura] [nvarchar](max) NULL,
	[Valor Fechamento] [nvarchar](max) NULL,
	[Valor Último Fechamento] [nvarchar](max) NULL,
	[Valor Minimo] [nvarchar](max) NULL,
	[Valor Medio] [nvarchar](max) NULL,
	[Valor Maximo] [nvarchar](max) NULL,
	[Valor Melhor Oferta Compra] [nvarchar](max) NULL,
	[Valor Melhor Oferta Venda] [nvarchar](max) NULL,
	[Valor Volume] [nvarchar](max) NULL,
	[Cód. ISIN] [nvarchar](50) NULL,
	[Ativo 2] [nvarchar](50) NULL,
	[index] [int] NULL
) 
*/

--Criando temporaria com cnpj padronizado para ligacao com outras tabelas
	SELECT	*,
			REPLACE(REPLACE(REPLACE(eb.tx_cnpj,'.', ''), '/', ''), '-', '') AS cnpj
		INTO #empresas_bolsa
		FROM [dbo].[empresas_bolsa1] eb

--Tabela unindo informacoes das Empresas
	TRUNCATE TABLE [dbo].[BI_EMP_FEmpresas]
	INSERT INTO [dbo].[BI_EMP_FEmpresas]
	SELECT	 em.[cnpj] as 'CNPJ'
			,eb.[tx_cnpj] as 'CNPJ Formatado'
			,em.[dt_abertura] as 'Data Abertura'
			,eb.nm_empresa as 'Nome Empresa'
		
			,em.[situacao_cadastral]  as 'Situação'
			,st.[saude_tributaria] as 'Saúde Tributária'
			,ep.[empresa_porte] as 'Porte'

			,CASE 
				WHEN  em.[matriz_empresaMatriz] = 1 THEN 'MATRIZ'
				ELSE 'FILIAL'
			END as 'Matriz/Filial'
			,CASE 
				WHEN  es.[optante_simples] is null THEN null
				WHEN  es.[optante_simples]  = 'true' THEN 'SIM' ELSE 'NÃO'
			END as 'Simples'
			,CASE 
				WHEN  es.[optante_simei] is null THEN null
				WHEN  es.[optante_simei]  = 'true' THEN 'SIM' ELSE 'NÃO'
			END as 'SIMEI'
			
			,em.[endereco_uf] as 'UF'
			,em.[endereco_mesorregiao] as 'Mesorregião'
			,em.[endereco_regiao] as 'Região'
			,em.[endereco_municipio] as 'Cidade'
			,em.[endereco_cep] as 'CEP'

			,em.[de_ramo_atividade] as 'Ramo Atividade'
			,na.[nivel_atividade] as 'Nível Atividade'
			,em.[de_setor] as 'Setor'
			,em.[cd_cnae_principal] as 'Cód. CNAE'
			,em.[de_cnae_principal] as 'Desc. CNAE'
				
			,CASE
				WHEN idade.[Anos_Empresa] <= 1 THEN 'até 1 ano'
				WHEN idade.[Anos_Empresa] > 1 and idade.[Anos_Empresa] <= 3 THEN '> 1 a 3 anos'
				WHEN idade.[Anos_Empresa] > 3 and idade.[Anos_Empresa] <= 5 THEN '> 3 a 5 anos'
				WHEN idade.[Anos_Empresa] > 5 and idade.[Anos_Empresa] <= 10 THEN '> 5 a 10 anos'
				WHEN idade.[Anos_Empresa] > 10 and idade.[Anos_Empresa] <= 20 THEN '> 10 a 20 anos'
				WHEN idade.[Anos_Empresa] > 20 and idade.[Anos_Empresa] <= 30 THEN '> 20 a 30 anos'
				WHEN idade.[Anos_Empresa] > 30 and idade.[Anos_Empresa] <= 50 THEN '> 30 a 50 anos'
				WHEN idade.[Anos_Empresa] > 50 THEN '> 50 anos'
				ELSE null
			END 'Faixa Tempo Empresa'
			,CASE
				WHEN idade.[Anos_Empresa] <= 1 THEN 1
				WHEN idade.[Anos_Empresa] > 1 and idade.[Anos_Empresa] <= 3 THEN 2
				WHEN idade.[Anos_Empresa] > 3 and idade.[Anos_Empresa] <= 5 THEN 3
				WHEN idade.[Anos_Empresa] > 5 and idade.[Anos_Empresa] <= 10 THEN 4
				WHEN idade.[Anos_Empresa] > 10 and idade.[Anos_Empresa] <= 20 THEN 5
				WHEN idade.[Anos_Empresa] > 20 and idade.[Anos_Empresa] <= 30 THEN 6
				WHEN idade.[Anos_Empresa] > 30 and idade.[Anos_Empresa] <= 50 THEN 7
				WHEN idade.[Anos_Empresa] > 50 THEN 8
				ELSE null
			END as 'Ordem Faixa'

			,eb.[cd_acao_rdz] as 'Acao RDZ'
			,eb.[setor_economico] as 'Setor bolsa'
			,eb.[subsetor] as 'Subsetor'
			,eb.[segmento] as 'Segmento'
			,eb.[segmento_b3] as 'Cód. Segmento B3'
			,eb.[nm_segmento_b3] as 'Segmento B3'
			,eb.[cd_acao] as 'Cód. Acao'
	  FROM [dbo].[df_empresas1] em WITH(NOLOCK)
		CROSS APPLY
			(
				SELECT  DATEDIFF(YEAR, em.dt_abertura,GETDATE()) as 'Anos_Empresa'
			)idade
		LEFT JOIN [dbo].[empresas_porte1] ep WITH(NOLOCK)
			ON em.cnpj = ep.cnpj
		LEFT JOIN [dbo].[empresas_nivel_atividade1] na WITH(NOLOCK)
			ON em.cnpj = na.cnpj
		LEFT JOIN [dbo].[empresas_simples1] es WITH(NOLOCK)
			ON em.cnpj = es.cnpj
		LEFT JOIN [dbo].[empresas_saude_tributaria1] st WITH(NOLOCK)
			ON em.cnpj = st.cnpj
		LEFT JOIN #empresas_bolsa eb 
			ON em.cnpj = eb.cnpj
		--WHERE em.cnpj = 42026683000104



--Tabela com informacoes das cotacoes
	
	TRUNCATE TABLE [dbo].[BI_EMP_Cotacoes1]
	INSERT INTO [dbo].[BI_EMP_Cotacoes1]
	SELECT	 cb.[id] as 'ID'
			,cb.[dt_pregao] as 'Data Pregão'

			
			,cb.[cd_acao] as 'Ativo'
			,cb.[nm_empresa_rdz] as 'Empresa'
			,cb.[moeda_ref] as 'Moeda'

			,cb.[vl_abertura] as 'Valor Abertura' 
			,cb.[vl_fechamento] as 'Valor Fechamento'	
			,ultimo.[vl_fechamento] as 'Valor Último Fechamento'
			
			,cb.[vl_minimo] as 'Valor Minimo'
			,cb.[vl_medio] as 'Valor Medio'
			,cb.[vl_maximo]	as 'Valor Maximo'

			,cb.[vl_mlh_oft_compra] as 'Valor Melhor Oferta Compra'
			,cb.[vl_mlh_oft_venda] as 'Valor Melhor Oferta Venda'
			,cb.[vl_volume] as 'Valor Volume'
			
			,cb.[cd_isin] as 'Cód. ISIN'
			,cb.[cd_acao_rdz] as 'Ativo 2'
			,cb.[index_level_0] as 'index'
		FROM  [dbo].[cotacoes_bolsa1] cb
			CROSS APPLY 
			(
				SELECT TOP 1 c1.vl_fechamento 
					FROM [dbo].[cotacoes_bolsa1]  c1
					WHERE c1.cd_acao = cb.cd_acao
					ORDER BY id desc
			)ultimo


