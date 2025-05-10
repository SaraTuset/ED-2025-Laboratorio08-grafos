unit uMatrixEdgeWeightedDigraph;

interface
  uses sysutils, uListaEnlazadaDoble;

  const
    MAX_NODES = 10;

  type

    tadjacency_matrix = array [1..MAX_NODES,1..MAX_NODES] of string;

    edgeWeightedDigraph = record
       matrix :      tadjacency_matrix;
       node_labels : array[1..MAX_NODES] of string;
       num_nodes:    integer;
    end;

  { -- FUNCIONES DE MANIPULACION DEL GRAFO -- }
  
  { Inicializar el grafo }
  { Inicializa el grafo vacío, configurando la matriz de adyacencia con valores 'inf' 
    y estableciendo el número de nodos en 0. }
  procedure initialize(var g: edgeWeightedDigraph);

  { Agregar un nodo al grafo }
  { Agrega un nodo al grafo si no existe ya y si no se ha alcanzado el límite máximo de nodos. }
  procedure add_node(var g: edgeWeightedDigraph; node: string);

  { Agregar un arco al grafo }
  { Agrega un arco dirigido entre dos nodos existentes en el grafo con un peso especificado. }
  procedure add_edge(var g: edgeWeightedDigraph; n1, n2, weight: string);

  { Eliminar un nodo del grafo }
  { Elimina un nodo del grafo, ajustando la matriz de adyacencia y las etiquetas de los nodos. }
  procedure delete_node(var g: edgeWeightedDigraph; node: string);

  { Eliminar un arco del grafo }
  { Elimina un arco dirigido entre dos nodos existentes en el grafo. }
  procedure delete_edge(var g: edgeWeightedDigraph; n1, n2: string);

  { -- FUNCIONES DE CONSULTA DEL GRAFO -- }

  { Determina si el grafo está vacío }
  { Devuelve true si el grafo no tiene nodos, false en caso contrario. }
  function is_empty(g: edgeWeightedDigraph): boolean;

  { Determina si un nodo está en el grafo }
  { Devuelve true si el nodo especificado existe en el grafo, false en caso contrario. }
  function node_in_graph(g: edgeWeightedDigraph; node: string): boolean;

  { Determina si un arco está en el grafo }
  { Devuelve true si existe un arco dirigido entre los nodos especificados, false en caso contrario. }
  function edge_in_graph(g: edgeWeightedDigraph; n1, n2: string): boolean;

  { Determina si un arco está en el grafo y retorna su peso }
  { Devuelve el peso del arco dirigido entre los nodos especificados, o 'inf' si no existe. }
  function edge_weight(g: edgeWeightedDigraph; n1, n2: string): string;

  { Determina si dos nodos son adyacentes }
  { Devuelve true si existe un arco dirigido entre los nodos especificados, false en caso contrario. }
  function adjacent(g: edgeWeightedDigraph; n1, n2: string): boolean;

  { Determina si el grafo tiene bucles }
  { Devuelve true si algún nodo tiene un arco dirigido hacia sí mismo, false en caso contrario. }
  function has_self_loops(g: edgeWeightedDigraph): boolean;

  { Calcula el grado total de un nodo }
  { Devuelve la suma de los grados de entrada y salida del nodo especificado. }
  function degree(var g: edgeWeightedDigraph; node: string): integer;

  { Calcula el grado de entrada de un nodo }
  { Devuelve el número de arcos que llegan al nodo especificado. }
  function indegree(var g: edgeWeightedDigraph; node: string): integer;

  { Calcula el grado de entrada ponderado de un nodo }
  { Devuelve la suma de los pesos de los arcos que llegan al nodo especificado. }
  function weighted_indegree(var g: edgeWeightedDigraph; node: string): integer;

  { Calcula el grado de salida de un nodo }
  { Devuelve el número de arcos que salen del nodo especificado. }
  function outdegree(var g: edgeWeightedDigraph; node: string): integer;

  { Calcula el grado de salida ponderado de un nodo }
  { Devuelve la suma de los pesos de los arcos que salen del nodo especificado. }
  function weighted_outdegree(var g: edgeWeightedDigraph; node: string): integer;


  { ---------- FUNCIONES DE VISUALIZACION ---------- }

  { Muestra el grafo en la consola }
  procedure show_matrix(g: edgeWeightedDigraph);

  { Muestra el grafo en la consola }
  procedure show(g: edgeWeightedDigraph);

  { --- OTROS METODOS --- }

  { Determina la densidad del grafo }
  { Devuelve la densidad del grafo como un valor real. }
  function density(g: edgeWeightedDigraph): real;

  { Determina si el grafo es completo }
  { Devuelve true si todos los nodos están conectados entre sí, false en caso contrario. }
  function is_complete(g: edgeWeightedDigraph): boolean;

  { Lista de vecinos de un nodo }
  { Devuelve una lista de los nodos adyacentes al nodo especificado. }
  procedure neighbors(g: edgeWeightedDigraph; node: string; var lista: tListaDoble);


implementation


  procedure initialize(var g: edgeWeightedDigraph);
  var i,j:integer;
  begin
    g.num_nodes:=0;
    for i:= 1 to MAX_NODES do begin
      g.node_labels[i]:= '';
      for j:= 1 to MAX_NODES do g.matrix[i,j]:= 'inf';
    end
  end;

  function get_index(g:edgeWeightedDigraph; node:string): integer;
  { retorna el índice en el array de un nodo por su etiqueta }
  var i, res : integer;
  begin
    res:= -1;
    i:= 0;
    while (res=-1) and (i<g.num_nodes) do begin
      i:= i+1;
      if g.node_labels[i]=node then res:= i;
    end;
    get_index:= res;
  end;

  procedure add_node(var g: edgeWeightedDigraph; node:string);
  begin
    if (g.num_nodes<MAX_NODES) and (not node_in_graph(g,node)) then begin
      g.num_nodes:= g.num_nodes + 1;
      g.node_labels[g.num_nodes]:= node;
    end;
  end;

  procedure add_edge(var g: edgeWeightedDigraph; n1,n2,weight: string);
  begin
    if node_in_graph(g,n1) and node_in_graph(g,n2) then begin
        g.matrix[get_index(g,n1),get_index(g,n2)]:= weight;
        //g.matrix[get_index(g,n2),get_index(g,n1)]:= weight; // grafo no dirigido
      end;
  end;

  procedure delete_node(var g: edgeWeightedDigraph; node:string);
  var i,k:integer;
  begin
    if node_in_graph(g,node) then begin
      k:= get_index(g,node);
      if k=g.num_nodes then // caso especial: eliminar el último nodo
        for i:=1 to g.num_nodes-1 do begin
            g.matrix[i,g.num_nodes]:='inf';
            g.matrix[g.num_nodes,i]:='inf';
        end
      else begin // eliminar sobreescribiendo su información con la del último
        for i:=1 to g.num_nodes-1 do begin
            g.matrix[i,k]:=g.matrix[i,g.num_nodes];
            g.matrix[i,g.num_nodes]:='inf';
            g.matrix[k,i]:=g.matrix[g.num_nodes,i];
            g.matrix[g.num_nodes,i]:='inf';
        end;
        g.matrix[k,k]:=g.matrix[g.num_nodes,g.num_nodes];
        g.node_labels[k]:= g.node_labels[g.num_nodes];
      end;
      g.matrix[g.num_nodes,g.num_nodes]:='inf';
      g.num_nodes:=g.num_nodes-1;
    end;
  end;

  procedure delete_edge(var g: edgeWeightedDigraph; n1,n2:string);
  begin
    if node_in_graph(g,n1) and node_in_graph(g,n2) then
      g.matrix[get_index(g,n1),get_index(g,n2)]:= 'inf';
  end;

  function is_empty(g: edgeWeightedDigraph): boolean;
  begin
    is_empty:= g.num_nodes=0
  end;

  function node_in_graph(g: edgeWeightedDigraph; node: string): boolean;
  begin
    node_in_graph:= get_index(g,node)<>-1;
  end;

  function edge_in_graph(g: edgeWeightedDigraph; n1,n2:string): boolean;
  var node1_index,node2_index: integer;
  begin
    node1_index:= get_index(g,n1);
    node2_index:= get_index(g,n2);
    edge_in_graph:= (node1_index <> -1) and
                    (node2_index <> -1) and
                    (g.matrix[node1_index,node2_index]<>'inf');
  end;

  function edge_weight(g: edgeWeightedDigraph; n1,n2:string): string;
  begin
    edge_weight:= g.matrix[get_index(g,n1),get_index(g,n2)];
  end;

  function adjacent(g: edgeWeightedDigraph; n1,n2:string): boolean;
  begin
    adjacent:= edge_in_graph(g,n1,n2);
  end;

  procedure show(g: edgeWeightedDigraph);
  var i,j: integer;
  begin
    writeln('Number of nodes: ', g.num_nodes);
    for i:=1 to g.num_nodes do begin
      writeln('Node: ', g.node_labels[i], ' - index in matrix: ', i);
      for j:= 1 to g.num_nodes do
        if g.matrix[i,j]<>'inf' then writeln('Edge: ', g.node_labels[i], ' , ', g.node_labels[j], ' weight: ', g.matrix[i,j]);
    end;
    show_matrix(g);
  end;

  procedure show_matrix(g: edgeWeightedDigraph);
  var i, j: integer;
  begin
    write('     '); // Espacio para la cabecera
    for i := 1 to g.num_nodes do
      write(g.node_labels[i]:5); // Imprime los nombres de los nodos como cabecera
    writeln;
    writeln('---------------------------');
    for i := 1 to g.num_nodes do begin
      write(g.node_labels[i]:5); // Imprime el nombre del nodo en la primera columna
      for j := 1 to g.num_nodes do
        write(g.matrix[i, j]:5);
      writeln;
    end;
    writeln('---------------------------');
  end;

  
  { Ejercicio 1.2 a) }
  function outdegree(var g: edgeWeightedDigraph; node:string): integer;
  var
    count, i, index: Integer;
  begin
      count:= 0;
      index := get_index(g, node);
      for i:= 1 to g.num_nodes do
        if g.matrix[index, i] <> 'inf' then
          count += 1;
      outdegree:= count;
  end;

  { Ejercicio 1.2 b) }
  function indegree(var g: edgeWeightedDigraph; node:string): integer;
  var
    count, i, index: Integer;
  begin
      count:= 0;
      index := get_index(g, node);
      for i:= 1 to g.num_nodes do
        if g.matrix[i, index] <> 'inf' then
          count += 1;
      indegree:= count;
  end;

  
    
  { Ejercicio 1.2 c) }
  function degree(var g: edgeWeightedDigraph; node:string): integer;
  begin
      degree:= indegree(g , node) + outdegree(g, node);
  end;



  { Ejercicio 1.3 a) }
  function weighted_indegree(var g: edgeWeightedDigraph; node:string): integer;
  var
    count, valResult, i, index: Integer;
  begin
      count:= 0;
      index := get_index(g, node);
      for i:= 1 to g.num_nodes do
        if g.matrix[i, index] <> 'inf' then
        begin
          Val(g.matrix[i, index], valResult);
          count += valResult;
        end;
      weighted_indegree:= count;
  end;

  
{ Ejercicio 1.3 b) }
function weighted_outdegree(var g: edgeWeightedDigraph; node:string): integer;
var
  count, valResult, i, index: Integer;
begin
    count:= 0;
    index := get_index(g, node);
    for i:= 1 to g.num_nodes do
      if g.matrix[index, i] <> 'inf' then
      begin
        Val(g.matrix[index, i], valResult);
        count +=  valResult;
      end;
    weighted_outdegree:= count;
end;

{ Ejercicio 1.4 }
function has_self_loops(g: edgeWeightedDigraph): boolean;
var
  i: Integer;
  loops: Boolean;
begin
  loops := False;
  i := 0;
  while (i < g.num_nodes) and not loops do
  begin
    i += 1;
    loops := g.matrix[i, i] <> 'inf';
  end;
  has_self_loops:= loops;
end;

{ Ejercicio 1.5 }
function num_edges(g: edgeWeightedDigraph): Integer;
var
  i, j, count: Integer;
begin
  count := 0;
  for i:= 1 to g.num_nodes do
    for j := 1 to g.num_nodes do
      if g.matrix[i,j] <> 'inf' then
         count += 1;
  num_edges := count;
end;

function density(g: edgeWeightedDigraph): real;
var
  e, n: Integer;
begin
  e:= num_edges(g);
  n:= g.num_nodes;
  density:= e / (n*(n-1));
end;

{ Ejercicio 1.6 }
function is_complete(g: edgeWeightedDigraph): boolean;
var
  i, j: Integer;
  complete: Boolean;
begin
  i:= 1;
  j:= 0;
  complete:= True;
  while (i < g.num_nodes) and complete do
    if j < g.num_nodes then
    begin
      j += 1;
      if i <> j then
         complete := g.matrix[i,j] <> 'inf';
    end else
    begin
      j := 0;
      i += 1;
    end;
  is_complete:= complete;
end;

{ Ejercicio 1.7 }
procedure neighbors(g: edgeWeightedDigraph; node: string; var lista: tListaDoble);
var
    i, index: Integer;
begin
  // Inicializa la lista de vecinos
  uListaEnlazadaDoble.initialize(lista);
  index := get_index(g, node);
  for i:= 1 to g.num_nodes do
      if (g.matrix[index, i] <> 'inf') and (i <> index) then
          uListaEnlazadaDoble.insert_at_end(lista,g.node_labels[i]);
end;


end.







