from IPython.display import Image, display
from langgraph.graph.graph import CompiledGraph


def draw_graph(graph: CompiledGraph):
    try:
        display(Image(graph.get_graph().draw_mermaid_png()))
    except Exception:
        pass


def save_graph(graph: CompiledGraph, file_name="graph.png"):
    try:
        graph.get_graph().draw_mermaid_png(output_file_path=file_name)
    except Exception:
        pass
