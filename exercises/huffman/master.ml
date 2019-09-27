(* -------------------------------------------------------------------------- *)

(* Building an alphabet out of a piece of text. *)

let build_alphabet (text : text) : alphabet =
  (* BEGIN INCLUDE *)
  (* TO DO: Define this function. *)
  raise TODO
  (* END INCLUDE *)
  (* BEGIN EXCLUDE
  let table = Hashtbl.create 256 in
  String.iter (fun symbol ->
    let freq =
      try
        Hashtbl.find table symbol
      with Not_found ->
        0
    in
    Hashtbl.replace table symbol (freq + 1)
  ) text;
  table
       END EXCLUDE *)

(* -------------------------------------------------------------------------- *)

(* Building encoding and decoding dictionaries out of an alphabet. *)

(* BEGIN INCLUDE *)
(* TO DO: Define a module [Q] that provides priority queues whose
   elements are pairs of a tree and an integer frequency. Drawing
   an element of the queue must yield an element whose frequency
   is minimum. *)
(*  END INCLUDE *)
(* BEGIN EXCLUDE
module Q =
  BinomialQueue(struct
    (* The priority queue contains pairs of a tree and a frequency. *)
    type t =
      tree * int
    (* Elements are compared based on their frequency. In other words,
       drawing an element out of the queue yields an element with least
       frequency. *)
    let compare (_, freq1) (_, freq2) =
      freq1 - freq2
  end)
     END EXCLUDE *)

let build_tree (alphabet : alphabet) : tree =
  (* Assumption: the alphabet has at least two symbols. *)
  assert (Hashtbl.length alphabet >= 2);
  (* BEGIN INCLUDE *)
  (* TO DO: Define this function. Use the module [Q] above. *)
  raise TODO
  (*   END INCLUDE *)
  (* BEGIN EXCLUDE
  (* Initialize a priority queue. *)
  let queue : Q.t =
    Hashtbl.fold (fun symbol freq queue ->
      Q.insert (Leaf symbol, freq) queue
    ) alphabet Q.empty
  in
  (* Process the priority queue. *)
  let rec process (queue : Q.t) : tree =
    (* Assumption: [queue] is nonempty. *)
    assert (not (Q.is_empty queue));
    let (tree0, freq0), queue = Q.extract queue in
    (* If the queue is now empty, we are done. *)
    if Q.is_empty queue then
      tree0
    else
      (* Otherwise, extract another tree. *)
      let (tree1, freq1), queue = Q.extract queue in
      (* Construct a new node, compute its cumulated frequency,
         insert it back into the queue, and continue. *)
      let tree = Node (tree0, tree1) in
      let freq = freq0 + freq1 in
      let queue = Q.insert (tree, freq) queue in
      process queue
  in
  process queue
     END EXCLUDE *)

let build_encoding_dictionary (tree : tree) : encoding_dictionary =
  (* BEGIN INCLUDE *)
  (* TO DO: Define this function. *)
  raise TODO
  (*   END INCLUDE *)
  (* BEGIN EXCLUDE
  let dictionary = Hashtbl.create 256 in
  let rec traverse (path : string) (tree : tree) : unit =
    match tree with
    | Leaf c ->
        Hashtbl.add dictionary c path
    | Node (tree0, tree1) ->
        traverse (path ^ "0") tree0;
        traverse (path ^ "1") tree1
  in
  traverse "" tree;
  dictionary
       END EXCLUDE *)

let build_dictionaries alphabet : encoding_dictionary * decoding_dictionary =
  let tree = build_tree alphabet in
  let encoding_dictionary = build_encoding_dictionary tree in
  let decoding_dictionary = tree in
  encoding_dictionary, decoding_dictionary

(* -------------------------------------------------------------------------- *)

(* Encoding input data. *)

let encode_char (dictionary : encoding_dictionary) (c : char) : data =
  try
    Hashtbl.find dictionary c
  with Not_found ->
    assert false (* unknown character *)

let encode (dictionary : encoding_dictionary) (text : text) : data =
  let buffer = Buffer.create 1024 in
  String.iter (fun c ->
    Buffer.add_string buffer (encode_char dictionary c)
  ) text;
  Buffer.contents buffer

(* -------------------------------------------------------------------------- *)

(* Decoding compressed data. *)

let rec find (data : data) (i : int) (t : tree) : char * int =
  assert (0 <= i && i <= String.length data);
(* BEGIN INCLUDE *)
  (* TO DO: Define this function. *)
  raise TODO
(*   END INCLUDE *)
(* BEGIN EXCLUDE
  match t with
  | Leaf c ->
      (* We are there. *)
      c, i
  | Node (t0, t1) ->
      (* [i] should be within bounds. *)
      assert (i < String.length data);
      (* [data] should contain valid binary data. *)
      assert (data.[i] = '0' || data.[i] = '1');
      (* Select an appropriate subtree based on the next bit,
         then continue. *)
      let t = if data.[i] = '0' then t0 else t1 in
      find data (i + 1) t
   END EXCLUDE *)

let decode (tree : tree) (data : data) (i : int) : text =
  let buffer = Buffer.create 1024 in
  let rec loop i =
    if i = String.length data then
      (* We have reached the end of the data. We are done. *)
      Buffer.contents buffer
    else begin
      (* Decode one more character, and continue. *)
      let c, i = find data i tree in
      Buffer.add_char buffer c;
      loop i
    end
  in
  loop i

(* -------------------------------------------------------------------------- *)

(* Serializing a tree means encoding it as binary data.
   Here, this means encoding it as a string of '0' and '1' characters. *)

let write (tree : tree) : data =
  let b = Buffer.create 1024 in
  let rec write (tree : tree) : unit =
    (* BEGIN INCLUDE *)
    (* TO DO: Define this auxiliary function. Hint: use [write_char]. *)
    raise TODO
    (*   END INCLUDE *)
    (* BEGIN EXCLUDE
    match tree with
    | Leaf c ->
        Buffer.add_char b '0';
        write_char b c
    | Node (tree0, tree1) ->
        Buffer.add_char b '1';
        write tree0;
        write tree1
         END EXCLUDE *)
  in
  write tree;
  Buffer.contents b

(* Deserializing a tree means reading its representation as binary data
   and transforming it back into a tree. *)

let read (s : data) : tree * int =
  let i = ref 0 in
  let next () : char =
    assert (!i < String.length s);
    let c = s.[!i] in
    incr i;
    c
  in
  let rec read () : tree =
    (* BEGIN INCLUDE *)
    (* TO DO: Define this auxiliary function. Hint: use [read_char]. *)
    raise TODO
    (*   END INCLUDE *)
    (* BEGIN EXCLUDE
    match next() with
    | '0' ->
        let c = read_char next in
        Leaf c
    | '1' ->
        let tree0 = read() in
        let tree1 = read() in
        Node (tree0, tree1)
    | _ ->
        assert false
         END EXCLUDE *)
  in
  let tree = read() in
  tree, !i

(* -------------------------------------------------------------------------- *)

(* Compressing and decompressing an input text. *)

let compress (text : text) : data =
  (* BEGIN INCLUDE *)
  (* TO DO: Define this function. *)
  raise TODO
  (* END INCLUDE *)
  (* BEGIN EXCLUDE
  let alphabet = build_alphabet text in
  let encoding_dictionary, decoding_dictionary = build_dictionaries alphabet in
  (* Write the decoding dictionary, followed with the encoded input data. *)
  write decoding_dictionary ^
  encode encoding_dictionary text
       END EXCLUDE *)

let decompress (data : data) : text =
  (* BEGIN INCLUDE *)
  (* TO DO: Define this function. *)
  raise TODO
  (* END INCLUDE *)
  (* BEGIN EXCLUDE
  (* Read the decoding dictionary. *)
  let decoding_dictionary, i = read data in
  (* Use it to decode the rest of the data. *)
  decode decoding_dictionary data i
       END EXCLUDE *)
