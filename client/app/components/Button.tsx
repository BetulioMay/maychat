"use client";
interface ButtonProps {
  text: string;
}
export default function Button({ text }: ButtonProps) {
  return (
    <button
      className="h-full w-full rounded-md"
      onClick={() => console.log("hello")}
    >
      <span className="font-bold text-white">{text}</span>
    </button>
  );
}
