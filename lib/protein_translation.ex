defmodule ProteinTranslation do

  @codons ["UGU", "UGC", "UUA", "UUG", "AUG", "UUU", "UUC", "UCU", "UCC", "UCA", "UCG", "UGG", "UAU", "UAC", "UAA", "UAG", "UGA"]

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    list = for <<x::binary-3 <- rna>>, do: x

    rna_in = Enum.all?(list, fn x ->
      Enum.member?(@codons, x)
    end)

    result = Enum.reduce(list, {}, fn x, _result ->
      case x do
        x when rna_in == true ->
          list =
            list
            |> Enum.reduce_while([], fn x, acc ->
              if x not in ["UAA", "UAG", "UGA"] do
                {:ok, protein} = ProteinTranslation.of_codon(x)
                {:cont, acc ++ [protein]}
              else
                {:halt, acc}
              end
            end)
          _result = {:ok, list}
        _ ->
          _result = {:error, "invalid RNA"}
      end
    end)
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    length = String.length(codon)
    case codon do
      "UGU" -> {:ok, "Cysteine"}
      "UGC" -> {:ok, "Cysteine"}
      "UUA" -> {:ok, "Leucine"}
      "UUG" -> {:ok, "Leucine"}
      "AUG" -> {:ok, "Methionine"}
      "UUU" -> {:ok, "Phenylalanine"}
      "UUC" -> {:ok, "Phenylalanine"}
      "UCU" -> {:ok, "Serine"}
      "UCC" -> {:ok, "Serine"}
      "UCA" -> {:ok, "Serine"}
      "UCG" -> {:ok, "Serine"}
      "UGG" -> {:ok, "Tryptophan"}
      "UAU" -> {:ok, "Tyrosine"}
      "UAC" -> {:ok, "Tyrosine"}
      "UAA" -> {:ok, "STOP"}
      "UAG" -> {:ok, "STOP"}
      "UGA" -> {:ok, "STOP"}
      codon when length != 3 ->
        {:error, "invalid codon"}
      # _ ->_result = {:error, "invalid RNA"}
    end
  end
end
