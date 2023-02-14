"use client";
import { HTMLInputTypeAttribute } from "react";

interface InputProps {
  value: string;
  type: HTMLInputTypeAttribute | undefined;
  placeholder?: string;
}
export default function Input({ value, type, placeholder }: InputProps) {
  return (
    <>
      <label className="m-2">{value}</label>
      <input
        className="rounded-xl p-2 shadow-md"
        placeholder={placeholder ? placeholder : value}
        type={type}
      ></input>
    </>
  );
}
