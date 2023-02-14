"use client";
import { FieldProps } from "formik";
import {
  DetailedHTMLProps,
  InputHTMLAttributes,
  LabelHTMLAttributes,
} from "react";

type InputProps = DetailedHTMLProps<
  LabelHTMLAttributes<HTMLLabelElement>,
  HTMLLabelElement
> &
  DetailedHTMLProps<InputHTMLAttributes<HTMLInputElement>, HTMLInputElement>;

interface OtherProps {
  label: string;
}

const InputField = ({
  label,
  field,
  ...props
}: FieldProps & InputProps & OtherProps) => {
  return (
    <>
      <label className="m-2" htmlFor={props.name}>
        {label}
      </label>
      <input className="rounded-xl p-2 shadow-md" {...field} {...props} />
    </>
  );
};

export default InputField;
