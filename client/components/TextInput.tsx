"use client";
import { FieldProps } from "formik";
import {
  DetailedHTMLProps,
  InputHTMLAttributes,
  LabelHTMLAttributes,
} from "react";

type TextInputProps = DetailedHTMLProps<
  LabelHTMLAttributes<HTMLLabelElement>,
  HTMLLabelElement
> &
  DetailedHTMLProps<InputHTMLAttributes<HTMLInputElement>, HTMLInputElement>;

interface OtherProps {
  label: string;
}

const TextInput = ({
  label,
  form: { touched, errors },
  field,
  ...props
}: FieldProps & TextInputProps & OtherProps) => {
  const error = touched[field.name] && errors[field.name];
  return (
    <>
      <label className="m-2" htmlFor={props.name}>
        {label}
      </label>
      <input className="rounded-xl p-2 shadow-md" {...field} {...props} />
      {error ? (
        <div className="ml-2 font-thin text-red-600">
          {errors[field.name] as string}
        </div>
      ) : null}
    </>
  );
};

export default TextInput;
