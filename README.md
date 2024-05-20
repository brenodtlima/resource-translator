# Recursos de tradução App

## Gerenciamento de estados

Para o projeto, foi escolhido o Provider para gerenciar o estado das telas. O mesmo se responsabiliza pelas atualização do ResourceRepository, repositório que contém a lista de recursos mostradas na tela inicial.

## Persistência de dados

Para armazenar os dados e não requisitar o url a cada inicialização do aplicativo, o SQLite foi usado para criar um banco de dados.

## Arquitetura

A arquitetura implementada foi a de MVC. 

  ResourceModel: estrutura dos dados
  
  ResourceView: visualização dos recursos na tela
  
  ResourceController: responsável pela comunicação com o banco de dados.

## Implementações

  custom_list_components.dart:
  
    _initializeResources() = Ao ser chamado no initState, irá verificar se já existe um banco de dados, e caso não, fará com que o controlador o crie

  custom_search_bar.dart:
  
    _fetchLanguages() = Atualiza os idiomas presentes nos dados usando o controlador e entregando ao provider
    _fetchModules() = Atualiza os módulos presentes nos dados usando o controlador e entregando ao provider

  resource_repositor.dart:
  
    set_languageId() = Define um novo ID de idioma a ser pesquisado e faz com que o controlador atualize a lista de recursos
    set_moduleId = Define um novo ID de módulo a ser pesquisado e faz o controlador atualizar a lista de recursos
    setResources = Atualiza a lista de recursos na tela

  resource_controller.dart:
  
    _initDatabase() =  Inicialize o banco de dados, se necessário
    insertResources() = Insira uma lista de recursos no banco de dados usando batches
    fetchAndStoreResources() = Caso a tabela esteja vazia, faça a solicitação http e carregue-a
    consultDataToRepository() = A cada alteração nas variáveis de pesquisa, cria outra consulta e atualiza a lista de recursos
    getDistinctLanguages() = Obtenha uma lista de todos os idiomas presentes nos dados
    getDistinctModules() = Obtenha uma lista de todos os IDs de módulos presentes nos dados
