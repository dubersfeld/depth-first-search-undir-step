# depth-first-search-undir-step
Java based demonstration of Depth First Search algorithm on an undirected graph using HTML5 Canvas, Javascript and AJAX.

I present here a Java based demonstration of the Depth First Search algorithm applied on an undirected graph.

The algorithm itself is implemented in Java. Javascript is used for initialization and display only.

The search itself is step-by-step, each Ajax request resulting in a new vertex discovery executed on server side.

A newly discovered vertex is colored in green. A finished vertex is colored in blue. 

When the search is completed all vertices are blue. Each vertex is labeled with its discovery time d, finishing time f and component number c with format:

d/f c


The root context when deployed on Tomcat is undirected-components


Dominique Ubersfeld, Cachan, France
