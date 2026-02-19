import tkinter as tk
from tkinter import ttk, messagebox
import psycopg2
from psycopg2 import Error

# CONFIGURAÇÕES DO BANCO DE DADOS 
DB_HOST = "pg-gerenciamento-esportivo.cwrgbdkjakez.us-east-1.rds.amazonaws.com" 
DB_NAME = "postgres" 
DB_USER = "postgres"
DB_PASS = "32491152"

def conectar():
    try:
        return psycopg2.connect(
            host=DB_HOST, 
            database=DB_NAME, 
            user=DB_USER, 
            password=DB_PASS,
            options="-c search_path=gestao_esportiva",
            sslmode="require"
        )
    except Error as e:
        messagebox.showerror("Erro de Conexão", f"Não foi possível conectar:\n{e}")
        return None
# INTERFACE GRÁFICA
class AppGestaoEsportiva:
    def __init__(self, root):
        self.root = root
        self.root.title("CRUD - Gestão Esportiva (Time, Empresa, Patrocínio)")
        self.root.geometry("850x650")

        self.notebook = ttk.Notebook(root)
        self.notebook.pack(fill='both', expand=True, padx=10, pady=10)

        self.tab_time = ttk.Frame(self.notebook)
        self.tab_empresa = ttk.Frame(self.notebook)
        self.tab_patrocinio = ttk.Frame(self.notebook)

        self.notebook.add(self.tab_time, text="1. Times")
        self.notebook.add(self.tab_empresa, text="2. Empresas")
        self.notebook.add(self.tab_patrocinio, text="3. Patrocínios")

        self.setup_tab_time()
        self.setup_tab_empresa()
        self.setup_tab_patrocinio()

    # ABA 1: TIME  com Auto-Meus_Times)
    def setup_tab_time(self):
        frame_form = ttk.LabelFrame(self.tab_time, text="Dados do Time")
        frame_form.pack(fill='x', padx=10, pady=5)

        ttk.Label(frame_form, text="ID (Automático):").grid(row=0, column=0, padx=5, pady=5, sticky='w')
        self.entry_time_id = ttk.Entry(frame_form, width=10)
        self.entry_time_id.grid(row=0, column=1, padx=5, pady=5, sticky='w')

        ttk.Label(frame_form, text="Nome:").grid(row=1, column=0, padx=5, pady=5, sticky='w')
        self.entry_time_nome = ttk.Entry(frame_form, width=40)
        self.entry_time_nome.grid(row=1, column=1, padx=5, pady=5)

        ttk.Label(frame_form, text="Ano:").grid(row=1, column=2, padx=5, pady=5, sticky='w')
        self.entry_time_ano = ttk.Entry(frame_form, width=10)
        self.entry_time_ano.grid(row=1, column=3, padx=5, pady=5)

        ttk.Label(frame_form, text="Cidade:").grid(row=2, column=0, padx=5, pady=5, sticky='w')
        self.entry_time_cidade = ttk.Entry(frame_form, width=40)
        self.entry_time_cidade.grid(row=2, column=1, padx=5, pady=5)

        frame_btn = ttk.Frame(self.tab_time)
        frame_btn.pack(fill='x', padx=10, pady=5)
        ttk.Button(frame_btn, text="Inserir", command=self.inserir_time).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Listar", command=self.listar_times).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Atualizar", command=self.atualizar_time).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Deletar", command=self.deletar_time).pack(side='left', padx=5)

        self.tree_time = ttk.Treeview(self.tab_time, columns=("ID", "Nome", "Ano", "Cidade"), show='headings')
        for col in ("ID", "Nome", "Ano", "Cidade"): self.tree_time.heading(col, text=col)
        self.tree_time.pack(fill='both', expand=True, padx=10, pady=10)
        self.tree_time.bind('<ButtonRelease-1>', lambda e: self.selecionar_tree(self.tree_time, [self.entry_time_id, self.entry_time_nome, self.entry_time_ano, self.entry_time_cidade]))

    def inserir_time(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                # Insere o Time e captura o ID gerado
                cursor.execute("INSERT INTO time (nome, ano_fundacao, cidade) VALUES (%s, %s, %s) RETURNING id_time", 
                               (self.entry_time_nome.get(), self.entry_time_ano.get(), self.entry_time_cidade.get()))
                id_time = cursor.fetchone()[0]
                # Auto-vincula à tabela meus_times invisivelmente
                cursor.execute("INSERT INTO meus_times (id_time) VALUES (%s)", (id_time,))
                conn.commit()
                messagebox.showinfo("Sucesso", "Time inserido com sucesso!")
                self.listar_times()
            except Error as e:
                messagebox.showerror("Erro SQL", f"Erro ao inserir:\n{e}")
            finally:
                conn.close()

    def listar_times(self):
        conn = conectar()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT id_time, nome, ano_fundacao, cidade FROM time")
            registros = cursor.fetchall()
            for i in self.tree_time.get_children(): self.tree_time.delete(i)
            for row in registros: self.tree_time.insert("", "end", values=row)
            conn.close()

    def atualizar_time(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute("UPDATE time SET nome=%s, ano_fundacao=%s, cidade=%s WHERE id_time=%s", 
                               (self.entry_time_nome.get(), self.entry_time_ano.get(), self.entry_time_cidade.get(), self.entry_time_id.get()))
                conn.commit()
                messagebox.showinfo("Sucesso", "Time atualizado!")
                self.listar_times()
            except Error as e:
                messagebox.showerror("Erro SQL", f"Erro:\n{e}")
            finally:
                conn.close()

    def deletar_time(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                # 1º: Deleta de meus_times (isso resolve o erro da sua imagem)
                cursor.execute("DELETE FROM meus_times WHERE id_time=%s", (self.entry_time_id.get(),))
                # 2º: Deleta de time
                cursor.execute("DELETE FROM time WHERE id_time=%s", (self.entry_time_id.get(),))
                conn.commit()
                messagebox.showinfo("Sucesso", "Time deletado com sucesso!")
                self.listar_times()
            except Error as e:
                messagebox.showerror("Erro", f"Erro ao deletar (verifique vínculos em outras tabelas):\n{e}")
            finally:
                conn.close()

    # ABA 2: EMPRESA )
    def setup_tab_empresa(self):
        frame_form = ttk.LabelFrame(self.tab_empresa, text="Dados da Empresa")
        frame_form.pack(fill='x', padx=10, pady=5)

        ttk.Label(frame_form, text="ID (Automático):").grid(row=0, column=0, padx=5, pady=5, sticky='w')
        self.entry_emp_id = ttk.Entry(frame_form, width=10)
        self.entry_emp_id.grid(row=0, column=1, padx=5, pady=5, sticky='w')

        ttk.Label(frame_form, text="CNPJ (14 dígitos):").grid(row=1, column=0, padx=5, pady=5, sticky='w')
        self.entry_emp_cnpj = ttk.Entry(frame_form, width=20)
        self.entry_emp_cnpj.grid(row=1, column=1, padx=5, pady=5)

        ttk.Label(frame_form, text="Nome Fantasia:").grid(row=2, column=0, padx=5, pady=5, sticky='w')
        self.entry_emp_nome = ttk.Entry(frame_form, width=30)
        self.entry_emp_nome.grid(row=2, column=1, padx=5, pady=5)

        ttk.Label(frame_form, text="Razão Social:").grid(row=2, column=2, padx=5, pady=5, sticky='w')
        self.entry_emp_razao = ttk.Entry(frame_form, width=30)
        self.entry_emp_razao.grid(row=2, column=3, padx=5, pady=5)

        frame_btn = ttk.Frame(self.tab_empresa)
        frame_btn.pack(fill='x', padx=10, pady=5)
        ttk.Button(frame_btn, text="Inserir", command=self.inserir_emp).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Listar", command=self.listar_emp).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Atualizar", command=self.atualizar_emp).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Deletar", command=self.deletar_emp).pack(side='left', padx=5)

        self.tree_emp = ttk.Treeview(self.tab_empresa, columns=("ID", "CNPJ", "Nome", "Razão Social"), show='headings')
        for col in ("ID", "CNPJ", "Nome", "Razão Social"): self.tree_emp.heading(col, text=col)
        self.tree_emp.pack(fill='both', expand=True, padx=10, pady=10)
        self.tree_emp.bind('<ButtonRelease-1>', lambda e: self.selecionar_tree(self.tree_emp, [self.entry_emp_id, self.entry_emp_cnpj, self.entry_emp_nome, self.entry_emp_razao]))

    def inserir_emp(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute("INSERT INTO empresa (cnpj, nome, razao_social) VALUES (%s, %s, %s)", 
                               (self.entry_emp_cnpj.get(), self.entry_emp_nome.get(), self.entry_emp_razao.get()))
                conn.commit()
                messagebox.showinfo("Sucesso", "Empresa inserida!"); self.listar_emp()
            except Error as e:
                messagebox.showerror("Erro SQL", f"Erro:\n{e}")
            finally:
                conn.close()

    def listar_emp(self):
        conn = conectar()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT id_empresa, cnpj, nome, razao_social FROM empresa")
            registros = cursor.fetchall()
            for i in self.tree_emp.get_children(): self.tree_emp.delete(i)
            for row in registros: self.tree_emp.insert("", "end", values=row)
            conn.close()

    def atualizar_emp(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute("UPDATE empresa SET cnpj=%s, nome=%s, razao_social=%s WHERE id_empresa=%s", 
                               (self.entry_emp_cnpj.get(), self.entry_emp_nome.get(), self.entry_emp_razao.get(), self.entry_emp_id.get()))
                conn.commit()
                messagebox.showinfo("Sucesso", "Empresa atualizada!"); self.listar_emp()
            except Error as e:
                messagebox.showerror("Erro SQL", f"Erro:\n{e}")
            finally:
                conn.close()

    def deletar_emp(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute("DELETE FROM empresa WHERE id_empresa=%s", (self.entry_emp_id.get(),))
                conn.commit()
                messagebox.showinfo("Sucesso", "Empresa deletada!"); self.listar_emp()
            except Error as e:
                messagebox.showerror("Erro", f"Não é possível deletar pois tem vínculos.\n{e}")
            finally:
                conn.close()

    # ABA 3: PATROCÍNIO (C R U D Usando ID_TIME)
    def setup_tab_patrocinio(self):
        frame_form = ttk.LabelFrame(self.tab_patrocinio, text="Vincular Patrocínio")
        frame_form.pack(fill='x', padx=10, pady=5)

        ttk.Label(frame_form, text="ID da Empresa:").grid(row=0, column=0, padx=5, pady=5, sticky='w')
        self.entry_pat_emp = ttk.Entry(frame_form, width=10)
        self.entry_pat_emp.grid(row=0, column=1, padx=5, pady=5)

        ttk.Label(frame_form, text="ID do Time:").grid(row=0, column=2, padx=5, pady=5, sticky='w')
        self.entry_pat_time = ttk.Entry(frame_form, width=10)
        self.entry_pat_time.grid(row=0, column=3, padx=5, pady=5)

        ttk.Label(frame_form, text="Valor (R$):").grid(row=1, column=0, padx=5, pady=5, sticky='w')
        self.entry_pat_valor = ttk.Entry(frame_form, width=15)
        self.entry_pat_valor.grid(row=1, column=1, padx=5, pady=5)

        ttk.Label(frame_form, text="Início (YYYY-MM-DD):").grid(row=2, column=0, padx=5, pady=5, sticky='w')
        self.entry_pat_inicio = ttk.Entry(frame_form, width=15)
        self.entry_pat_inicio.grid(row=2, column=1, padx=5, pady=5)

        ttk.Label(frame_form, text="Fim (YYYY-MM-DD):").grid(row=2, column=2, padx=5, pady=5, sticky='w')
        self.entry_pat_fim = ttk.Entry(frame_form, width=15)
        self.entry_pat_fim.grid(row=2, column=3, padx=5, pady=5)

        frame_btn = ttk.Frame(self.tab_patrocinio)
        frame_btn.pack(fill='x', padx=10, pady=5)
        ttk.Button(frame_btn, text="Inserir", command=self.inserir_pat).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Listar", command=self.listar_pat).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Atualizar", command=self.atualizar_pat).pack(side='left', padx=5)
        ttk.Button(frame_btn, text="Deletar", command=self.deletar_pat).pack(side='left', padx=5)

        # Atualizado para listar o ID Time
        self.tree_pat = ttk.Treeview(self.tab_patrocinio, columns=("ID Emp", "ID Time", "Valor R$", "Início", "Fim"), show='headings')
        for col in ("ID Emp", "ID Time", "Valor R$", "Início", "Fim"): self.tree_pat.heading(col, text=col)
        self.tree_pat.pack(fill='both', expand=True, padx=10, pady=10)
        self.tree_pat.bind('<ButtonRelease-1>', lambda e: self.selecionar_tree(self.tree_pat, [self.entry_pat_emp, self.entry_pat_time, self.entry_pat_valor, self.entry_pat_inicio, self.entry_pat_fim]))

    def get_id_meu_time(self, cursor, id_time):
        """Busca o id_meu_time equivalente para manter a regra de negócio invisível para o usuário"""
        cursor.execute("SELECT id_meu_time FROM meus_times WHERE id_time = %s", (id_time,))
        row = cursor.fetchone()
        if row: return row[0]
        return None

    def inserir_pat(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                id_mt = self.get_id_meu_time(cursor, self.entry_pat_time.get())
                if not id_mt:
                    messagebox.showerror("Erro", "Time não encontrado!")
                    return
                cursor.execute("INSERT INTO patrocinio (id_empresa, id_meu_time, valor_contrato, data_contrato, data_contrato_fim) VALUES (%s, %s, %s, %s, %s)", 
                               (self.entry_pat_emp.get(), id_mt, self.entry_pat_valor.get(), self.entry_pat_inicio.get(), self.entry_pat_fim.get()))
                conn.commit()
                messagebox.showinfo("Sucesso", "Patrocínio inserido!"); self.listar_pat()
            except Error as e:
                messagebox.showerror("Erro SQL", f"Erro:\n{e}")
            finally:
                conn.close()

    def listar_pat(self):
        conn = conectar()
        if conn:
            cursor = conn.cursor()
            # O JOIN garante que o usuário veja o ID_TIME na tela, e não o id_meu_time
            query = """SELECT p.id_empresa, mt.id_time, p.valor_contrato, p.data_contrato, p.data_contrato_fim 
                       FROM patrocinio p 
                       JOIN meus_times mt ON p.id_meu_time = mt.id_meu_time"""
            cursor.execute(query)
            registros = cursor.fetchall()
            for i in self.tree_pat.get_children(): self.tree_pat.delete(i)
            for row in registros: self.tree_pat.insert("", "end", values=row)
            conn.close()

    def atualizar_pat(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                id_mt = self.get_id_meu_time(cursor, self.entry_pat_time.get())
                cursor.execute("UPDATE patrocinio SET valor_contrato=%s, data_contrato=%s, data_contrato_fim=%s WHERE id_empresa=%s AND id_meu_time=%s", 
                               (self.entry_pat_valor.get(), self.entry_pat_inicio.get(), self.entry_pat_fim.get(), self.entry_pat_emp.get(), id_mt))
                conn.commit()
                messagebox.showinfo("Sucesso", "Patrocínio atualizado!"); self.listar_pat()
            except Error as e:
                messagebox.showerror("Erro SQL", f"Erro:\n{e}")
            finally:
                conn.close()

    def deletar_pat(self):
        conn = conectar()
        if conn:
            try:
                cursor = conn.cursor()
                id_mt = self.get_id_meu_time(cursor, self.entry_pat_time.get())
                cursor.execute("DELETE FROM patrocinio WHERE id_empresa=%s AND id_meu_time=%s", (self.entry_pat_emp.get(), id_mt))
                conn.commit()
                messagebox.showinfo("Sucesso", "Patrocínio deletado!"); self.listar_pat()
            except Error as e:
                messagebox.showerror("Erro", f"Erro ao deletar:\n{e}")
            finally:
                conn.close()

    def selecionar_tree(self, tree, entry_list):
        item = tree.selection()
        if item:
            valores = tree.item(item, 'values')
            for entry, val in zip(entry_list, valores):
                if entry: entry.delete(0, tk.END); entry.insert(tk.END, val)

if __name__ == "__main__":
    root = tk.Tk()
    app = AppGestaoEsportiva(root)
    root.mainloop()